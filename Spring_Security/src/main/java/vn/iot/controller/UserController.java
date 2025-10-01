package vn.iot.controller;

import org.springframework.web.bind.annotation.*;
import vn.iot.entity.User;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    private List<User> users = new ArrayList<>();

    public UserController() {
        // Khởi tạo dữ liệu mẫu
        users.add(new User("001", "Nguyễn Hữu Trung", "090861710", "trungnhapkt@gmail.com", "123", "ROLE_ADMIN"));
        users.add(new User("002", "Nguyễn Văn A", "090123456", "vana@gmail.com", "123", "ROLE_USER"));
    }

    @GetMapping("/all")
    public List<User> getAllUsers() {
        return users;
    }

    @GetMapping("/{id}")
    public User getUserById(@PathVariable String id) {
        return users.stream()
                .filter(user -> user.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    @PostMapping("/new")
    public String addUser(@RequestBody User user) {
        // Tạo ID mới
        String newId = String.format("%03d", users.size() + 1);
        user.setId(newId);
        
        users.add(user);
        return "Thêm user thành công!";
    }

    @PutMapping("/{id}")
    public String updateUser(@PathVariable String id, @RequestBody User user) {
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId().equals(id)) {
                user.setId(id);
                users.set(i, user);
                return "Cập nhật user thành công!";
            }
        }
        return "Không tìm thấy user!";
    }

    @DeleteMapping("/{id}")
    public String deleteUser(@PathVariable String id) {
        users.removeIf(user -> user.getId().equals(id));
        return "Xóa user thành công!";
    }
}
