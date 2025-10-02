package vn.hcmute.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.hcmute.dto.AuthRequest;
import vn.hcmute.dto.AuthResponse;
import vn.hcmute.dto.LoginRequest;
import vn.hcmute.service.AuthService;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {
    
    private final AuthService authService;
    private final PasswordEncoder passwordEncoder;
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody AuthRequest request) {
        try {
            System.out.println("Register request received: " + request);
            AuthResponse response = authService.register(request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            System.out.println("Register error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Registration failed: " + e.getMessage());
        }
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest request) {
        try {
            System.out.println("Login request received: " + request);
            AuthResponse response = authService.login(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            System.out.println("Login error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Login failed: " + e.getMessage());
        }
    }
    
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody Map<String, String> request) {
        try {
            String refreshToken = request.get("refreshToken");
            if (refreshToken == null || refreshToken.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Refresh token is required");
            }
            AuthResponse response = authService.refreshToken(refreshToken);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body("Token refresh failed: " + e.getMessage());
        }
    }
    
    @GetMapping("/public/test")
    public ResponseEntity<String> test() {
        return ResponseEntity.ok("Test endpoint working!");
    }
    
    @GetMapping("/public/generate-password")
    public ResponseEntity<String> generatePassword(@RequestParam String password) {
        String hashed = passwordEncoder.encode(password);
        return ResponseEntity.ok("Password: " + password + "\nHashed: " + hashed);
    }
    
    @PostMapping("/test")
    public ResponseEntity<String> test(@RequestBody String body) {
        System.out.println("Test endpoint called with body: " + body);
        return ResponseEntity.ok("Test endpoint working! Body: " + body);
    }
    
    @PostMapping("/debug")
    public ResponseEntity<String> debug(@RequestBody AuthRequest request) {
        System.out.println("Debug endpoint called with request: " + request);
        return ResponseEntity.ok("Debug endpoint working! Username: " + request.getUsername() + ", Email: " + request.getEmail());
    }
    
    @PostMapping("/simple-register")
    public ResponseEntity<String> simpleRegister(@RequestBody AuthRequest request) {
        System.out.println("Simple register called with: " + request);
        try {
            AuthResponse response = authService.register(request);
            return ResponseEntity.ok("User registered successfully: " + response.getUsername());
        } catch (Exception e) {
            System.out.println("Simple register error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        }
    }
}
