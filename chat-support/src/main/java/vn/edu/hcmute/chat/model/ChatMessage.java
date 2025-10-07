package vn.edu.hcmute.chat.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * Model đại diện cho một tin nhắn chat
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage {
    
    /**
     * Loại tin nhắn: JOIN, LEAVE, CHAT, TYPING
     */
    public enum MessageType {
        CHAT,     // Tin nhắn thông thường
        JOIN,     // User tham gia phòng chat
        LEAVE,    // User rời phòng chat
        TYPING    // User đang gõ
    }
    
    private MessageType type;
    private String content;        // Nội dung tin nhắn
    private String sender;         // Người gửi
    private String receiver;       // Người nhận (null nếu là tin nhắn công khai)
    private String roomId;         // ID phòng chat
    private LocalDateTime timestamp; // Thời gian gửi
    
    // Constructor cho tin nhắn thông thường
    public ChatMessage(MessageType type, String content, String sender, String roomId) {
        this.type = type;
        this.content = content;
        this.sender = sender;
        this.roomId = roomId;
        this.timestamp = LocalDateTime.now();
    }
    
    // Constructor cho tin nhắn riêng tư
    public ChatMessage(MessageType type, String content, String sender, String receiver, String roomId) {
        this.type = type;
        this.content = content;
        this.sender = sender;
        this.receiver = receiver;
        this.roomId = roomId;
        this.timestamp = LocalDateTime.now();
    }
}