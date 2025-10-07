package vn.edu.hcmute.chat.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import vn.edu.hcmute.chat.model.ChatMessage;
import vn.edu.hcmute.chat.model.ChatUser;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Service quản lý chat rooms và users
 * Trong thực tế, dữ liệu này nên được lưu vào database
 */
@Slf4j
@Service
public class ChatService {
    
    // Map lưu trữ users online theo room
    private final Map<String, Set<String>> roomUsers = new ConcurrentHashMap<>();
    
    // Map lưu trữ thông tin users
    private final Map<String, ChatUser> users = new ConcurrentHashMap<>();
    
    // Map lưu trữ lịch sử tin nhắn theo room (trong memory - demo only)
    private final Map<String, List<ChatMessage>> roomMessages = new ConcurrentHashMap<>();

    /**
     * Thêm user vào phòng chat
     */
    public void addUserToRoom(String username, String roomId) {
        roomUsers.computeIfAbsent(roomId, k -> ConcurrentHashMap.newKeySet()).add(username);
        
        // Tạo hoặc cập nhật user info
        users.put(username, new ChatUser(username, username, ChatUser.UserRole.CUSTOMER));
        
        log.info("User {} added to room {}. Room now has {} users", 
                username, roomId, roomUsers.get(roomId).size());
    }

    /**
     * Xóa user khỏi phòng chat
     */
    public void removeUserFromRoom(String username, String roomId) {
        Set<String> roomUserSet = roomUsers.get(roomId);
        if (roomUserSet != null) {
            roomUserSet.remove(username);
            if (roomUserSet.isEmpty()) {
                roomUsers.remove(roomId);
            }
        }
        
        log.info("User {} removed from room {}", username, roomId);
    }

    /**
     * Lấy danh sách users trong phòng
     */
    public Set<String> getUsersInRoom(String roomId) {
        return roomUsers.getOrDefault(roomId, Collections.emptySet());
    }

    /**
     * Lưu tin nhắn (trong thực tế nên lưu vào database)
     */
    public void saveMessage(ChatMessage message) {
        String roomId = message.getRoomId();
        roomMessages.computeIfAbsent(roomId, k -> new ArrayList<>()).add(message);
        
        log.info("Message saved for room {}: {} from {}", 
                roomId, message.getContent(), message.getSender());
    }

    /**
     * Lấy lịch sử tin nhắn của phòng
     */
    public List<ChatMessage> getRoomMessages(String roomId) {
        return roomMessages.getOrDefault(roomId, Collections.emptyList());
    }

    /**
     * Lấy lịch sử tin nhắn gần nhất
     */
    public List<ChatMessage> getRecentMessages(String roomId, int limit) {
        List<ChatMessage> messages = getRoomMessages(roomId);
        int fromIndex = Math.max(0, messages.size() - limit);
        return messages.subList(fromIndex, messages.size());
    }

    /**
     * Kiểm tra xem user có trong phòng không
     */
    public boolean isUserInRoom(String username, String roomId) {
        Set<String> roomUserSet = roomUsers.get(roomId);
        return roomUserSet != null && roomUserSet.contains(username);
    }

    /**
     * Lấy thông tin user
     */
    public ChatUser getUserInfo(String username) {
        return users.get(username);
    }

    /**
     * Cập nhật vai trò user (customer, support, admin)
     */
    public void updateUserRole(String username, ChatUser.UserRole role) {
        ChatUser user = users.get(username);
        if (user != null) {
            user.setRole(role);
            log.info("Updated role for user {} to {}", username, role);
        }
    }

    /**
     * Lấy danh sách tất cả rooms đang hoạt động
     */
    public Set<String> getActiveRooms() {
        return roomUsers.keySet();
    }

    /**
     * Lấy số lượng users online
     */
    public int getTotalOnlineUsers() {
        return users.size();
    }

    /**
     * Xóa tất cả users khỏi tất cả rooms (cleanup)
     */
    public void clearAllRooms() {
        roomUsers.clear();
        users.clear();
        roomMessages.clear();
        log.info("All rooms and users cleared");
    }
}