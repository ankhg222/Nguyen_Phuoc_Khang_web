package vn.edu.hcmute.chat.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import vn.edu.hcmute.chat.model.ChatMessage;
import vn.edu.hcmute.chat.service.ChatService;

import java.time.LocalDateTime;

/**
 * Controller xử lý các tin nhắn WebSocket
 * 
 * Luồng hoạt động:
 * 1. Client gửi tin nhắn đến /app/chat.sendMessage/{roomId}
 * 2. Server xử lý và broadcast đến /topic/public/{roomId}
 * 3. Tất cả clients subscribe /topic/public/{roomId} sẽ nhận được tin nhắn
 */
@Slf4j
@Controller
public class ChatController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;
    
    @Autowired
    private ChatService chatService;

    /**
     * Xử lý tin nhắn chat thông thường
     * @param roomId ID của phòng chat
     * @param chatMessage Tin nhắn từ client
     * @return Tin nhắn được broadcast đến tất cả clients trong phòng
     */
    @MessageMapping("/chat.sendMessage/{roomId}")
    @SendTo("/topic/public/{roomId}")
    public ChatMessage sendMessage(@DestinationVariable String roomId, 
                                 @Payload ChatMessage chatMessage) {
        
        log.info("Received message in room {}: {} from {}", 
                roomId, chatMessage.getContent(), chatMessage.getSender());
        
        // Set thời gian và room ID
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setRoomId(roomId);
        
        // Lưu tin nhắn vào database (nếu cần)
        chatService.saveMessage(chatMessage);
        
        return chatMessage;
    }

    /**
     * Xử lý khi user tham gia phòng chat
     * @param roomId ID của phòng chat
     * @param chatMessage Tin nhắn JOIN
     * @param headerAccessor Accessor để lấy session attributes
     * @return Thông báo user đã tham gia
     */
    @MessageMapping("/chat.addUser/{roomId}")
    @SendTo("/topic/public/{roomId}")
    public ChatMessage addUser(@DestinationVariable String roomId,
                              @Payload ChatMessage chatMessage,
                              SimpMessageHeaderAccessor headerAccessor) {
        
        // Thêm username vào session attributes
        headerAccessor.getSessionAttributes().put("username", chatMessage.getSender());
        headerAccessor.getSessionAttributes().put("roomId", roomId);
        
        log.info("User {} joined room {}", chatMessage.getSender(), roomId);
        
        // Đăng ký user với chat service
        chatService.addUserToRoom(chatMessage.getSender(), roomId);
        
        chatMessage.setType(ChatMessage.MessageType.JOIN);
        chatMessage.setContent(chatMessage.getSender() + " đã tham gia cuộc trò chuyện!");
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setRoomId(roomId);
        
        return chatMessage;
    }

    /**
     * Gửi tin nhắn riêng tư đến một user cụ thể
     * @param chatMessage Tin nhắn private
     */
    @MessageMapping("/chat.sendPrivate")
    public void sendPrivateMessage(@Payload ChatMessage chatMessage) {
        
        log.info("Sending private message from {} to {}: {}", 
                chatMessage.getSender(), chatMessage.getReceiver(), chatMessage.getContent());
        
        chatMessage.setTimestamp(LocalDateTime.now());
        
        // Gửi tin nhắn đến user cụ thể
        messagingTemplate.convertAndSendToUser(
                chatMessage.getReceiver(), 
                "/queue/private", 
                chatMessage
        );
        
        // Lưu tin nhắn private (nếu cần)
        chatService.saveMessage(chatMessage);
    }

    /**
     * Xử lý thông báo user đang gõ
     * @param roomId ID của phòng chat
     * @param chatMessage Tin nhắn TYPING
     */
    @MessageMapping("/chat.typing/{roomId}")
    @SendTo("/topic/typing/{roomId}")
    public ChatMessage handleTyping(@DestinationVariable String roomId,
                                   @Payload ChatMessage chatMessage) {
        
        chatMessage.setType(ChatMessage.MessageType.TYPING);
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessage.setRoomId(roomId);
        
        return chatMessage;
    }
}