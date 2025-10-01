package vn.iot.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    private String id;
    private String name;
    private String phoneNumber;
    private String email;
    private String password;
    private String rules; // ROLE_ADMIN hoặc ROLE_USER
}
