package vn.edu.hcmute.chat.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Model đại diện cho một user trong hệ thống chat
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatUser {
    
    /**
     * Vai trò của user trong hệ thống
     */
    public enum UserRole {
        CUSTOMER,    // Khách hàng
        SUPPORT,     // Nhân viên hỗ trợ
        ADMIN        // Quản trị viên
    }
    
    /**
     * Trạng thái online của user
     */
    public enum UserStatus {
        ONLINE,
        OFFLINE,
        AWAY,
        BUSY
    }
    
    private String username;
    private String displayName;
    private UserRole role;
    private UserStatus status;
    private String currentRoom;  // Phòng chat hiện tại
    private String sessionId;    // Session ID của WebSocket
    
    public ChatUser(String username, String displayName, UserRole role) {
        this.username = username;
        this.displayName = displayName;
        this.role = role;
        this.status = UserStatus.ONLINE;
    }
}