package vn.edu.hcmute.chat.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.SessionConnectedEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;
import vn.edu.hcmute.chat.model.ChatMessage;
import vn.edu.hcmute.chat.service.ChatService;

import java.time.LocalDateTime;

/**
 * Listener xử lý các sự kiện WebSocket
 * - Khi user connect/disconnect
 * - Tự động thông báo cho các users khác
 */
@Slf4j
@Component
public class WebSocketEventListener {

    @Autowired
    private SimpMessageSendingOperations messagingTemplate;

    @Autowired
    private ChatService chatService;

    /**
     * Xử lý sự kiện khi user kết nối WebSocket thành công
     */
    @EventListener
    public void handleWebSocketConnectListener(SessionConnectedEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        String sessionId = headerAccessor.getSessionId();
        
        log.info("New WebSocket connection established. Session ID: {}", sessionId);
    }

    /**
     * Xử lý sự kiện khi user ngắt kết nối WebSocket
     * Tự động thông báo cho các users khác trong cùng room
     */
    @EventListener
    public void handleWebSocketDisconnectListener(SessionDisconnectEvent event) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.wrap(event.getMessage());
        
        String username = (String) headerAccessor.getSessionAttributes().get("username");
        String roomId = (String) headerAccessor.getSessionAttributes().get("roomId");
        String sessionId = headerAccessor.getSessionId();
        
        log.info("WebSocket connection closed. Session ID: {}, Username: {}, Room: {}", 
                sessionId, username, roomId);
        
        if (username != null && roomId != null) {
            // Xóa user khỏi room
            chatService.removeUserFromRoom(username, roomId);
            
            // Tạo tin nhắn thông báo user đã rời
            ChatMessage chatMessage = new ChatMessage(
                    ChatMessage.MessageType.LEAVE,
                    username + " đã rời khỏi cuộc trò chuyện!",
                    username,
                    roomId
            );
            chatMessage.setTimestamp(LocalDateTime.now());
            
            // Gửi thông báo đến tất cả users trong room
            messagingTemplate.convertAndSend("/topic/public/" + roomId, chatMessage);
            
            log.info("Sent leave notification for user {} in room {}", username, roomId);
        }
    }
}