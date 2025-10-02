package vn.hcmute.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordHashTester {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        
        // Hash cần kiểm tra
        String hashToTest = "$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi.";
        
        // Danh sách các mật khẩu phổ biến để test
        String[] commonPasswords = {
            "password123",
            "test123", 
            "admin123",
            "123456",
            "password",
            "test",
            "admin",
            "user123",
            "newuser123",
            "testuser",
            "hello123",
            "welcome123"
        };
        
        System.out.println("Testing hash: " + hashToTest);
        System.out.println("==================================================");
        
        for (String password : commonPasswords) {
            boolean matches = encoder.matches(password, hashToTest);
            System.out.println("Password: '" + password + "' -> " + (matches ? "✅ MATCH!" : "❌ No match"));
            
            if (matches) {
                System.out.println("🎯 FOUND! The password is: " + password);
                break;
            }
        }
        
        System.out.println("==================================================");
        System.out.println("Generating new hashes for common passwords:");
        
        for (String password : new String[]{"password123", "test123", "admin123"}) {
            String newHash = encoder.encode(password);
            System.out.println("Password: '" + password + "'");
            System.out.println("New Hash: " + newHash);
            System.out.println("Verify: " + encoder.matches(password, newHash));
            System.out.println("---");
        }
    }
}