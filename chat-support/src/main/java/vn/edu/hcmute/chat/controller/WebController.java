package vn.edu.hcmute.chat.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import vn.edu.hcmute.chat.service.ChatService;

/**
 * Controller xử lý các trang web cho giao diện chat
 */
@Controller
public class WebController {

    @Autowired
    private ChatService chatService;

    /**
     * Trang chủ - Chọn username và room
     */
    @GetMapping("/")
    public String index() {
        return "index";
    }

    /**
     * Trang chat chính
     * @param username Tên user
     * @param roomId ID phòng chat
     * @param model Model để truyền dữ liệu sang view
     */
    @GetMapping("/chat")
    public String chat(@RequestParam String username, 
                      @RequestParam String roomId, 
                      Model model) {
        
        model.addAttribute("username", username);
        model.addAttribute("roomId", roomId);
        
        // Lấy lịch sử tin nhắn gần nhất (10 tin nhắn cuối)
        model.addAttribute("recentMessages", chatService.getRecentMessages(roomId, 10));
        
        return "chat";
    }

    /**
     * Trang chat cho khách hàng (simplified interface)
     */
    @GetMapping("/customer")
    public String customerChat() {
        return "customer";
    }

    /**
     * Trang chat cho nhân viên hỗ trợ (advanced interface)
     */
    @GetMapping("/support")
    public String supportChat() {
        return "support";
    }

    /**
     * Trang admin để quản lý chat rooms
     */
    @GetMapping("/admin")
    public String adminPanel(Model model) {
        model.addAttribute("activeRooms", chatService.getActiveRooms());
        model.addAttribute("totalOnlineUsers", chatService.getTotalOnlineUsers());
        return "admin";
    }

    /**
     * Trang chat room cụ thể
     */
    @GetMapping("/room/{roomId}")
    public String chatRoom(@PathVariable String roomId, 
                          @RequestParam(required = false) String username,
                          Model model) {
        
        if (username == null || username.trim().isEmpty()) {
            return "redirect:/?room=" + roomId;
        }
        
        model.addAttribute("username", username);
        model.addAttribute("roomId", roomId);
        model.addAttribute("usersInRoom", chatService.getUsersInRoom(roomId));
        model.addAttribute("recentMessages", chatService.getRecentMessages(roomId, 20));
        
        return "room";
    }
}