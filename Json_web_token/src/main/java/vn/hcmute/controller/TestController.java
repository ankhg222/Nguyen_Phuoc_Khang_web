package vn.hcmute.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/test")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class TestController {
    
    @GetMapping("/public")
    public ResponseEntity<String> publicEndpoint() {
        return ResponseEntity.ok("This is a public endpoint - no authentication required!");
    }
    
    @GetMapping("/user")
    public ResponseEntity<String> userEndpoint(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok("Hello " + username + "! This is a protected endpoint for authenticated users.");
    }
    
    @GetMapping("/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<String> adminEndpoint(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok("Hello " + username + "! This is an admin-only endpoint.");
    }
    
    @GetMapping("/moderator")
    @PreAuthorize("hasRole('MODERATOR')")
    public ResponseEntity<String> moderatorEndpoint(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok("Hello " + username + "! This is a moderator-only endpoint.");
    }
    
    @GetMapping("/profile")
    public ResponseEntity<Object> getUserProfile(Authentication authentication) {
        return ResponseEntity.ok(authentication.getPrincipal());
    }
}
