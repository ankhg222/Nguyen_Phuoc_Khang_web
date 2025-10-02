package vn.hcmute.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import vn.hcmute.dto.AuthRequest;
import vn.hcmute.dto.AuthResponse;
import vn.hcmute.dto.LoginRequest;
import vn.hcmute.entity.User;
import vn.hcmute.repository.UserRepository;
import vn.hcmute.util.JwtUtil;

@Service
@RequiredArgsConstructor
public class AuthService {
    
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    
    public AuthResponse register(AuthRequest request) {
        System.out.println("AuthService.register called with: " + request);
        
        // Check if user already exists
        if (userRepository.existsByUsername(request.getUsername())) {
            System.out.println("Username already exists: " + request.getUsername());
            throw new RuntimeException("Username is already taken!");
        }
        
        if (userRepository.existsByEmail(request.getEmail())) {
            System.out.println("Email already exists: " + request.getEmail());
            throw new RuntimeException("Email is already in use!");
        }
        
        // Create new user
        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(User.Role.USER)
                .build();
        
        userRepository.save(user);
        
        // Generate tokens
        UserDetails userDetails = user;
        String accessToken = jwtUtil.generateToken(userDetails);
        String refreshToken = jwtUtil.generateRefreshToken(userDetails);
        
        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .username(user.getUsername())
                .email(user.getEmail())
                .role(user.getRole().name())
                .expiresIn(86400000L) // 24 hours
                .build();
    }
    
    public AuthResponse login(LoginRequest request) {
        System.out.println("AuthService.login called with usernameOrEmail: " + request.getUsernameOrEmail());
        
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            request.getUsernameOrEmail(),
                            request.getPassword()
                    )
            );
            
            System.out.println("Authentication successful");
            
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String accessToken = jwtUtil.generateToken(userDetails);
            String refreshToken = jwtUtil.generateRefreshToken(userDetails);
            
            // Find user by username or email
            User user = userRepository.findByUsername(request.getUsernameOrEmail())
                    .orElseGet(() -> userRepository.findByEmail(request.getUsernameOrEmail())
                            .orElseThrow(() -> new RuntimeException("User not found")));
            
            System.out.println("User found: " + user.getUsername());
            
            return AuthResponse.builder()
                    .accessToken(accessToken)
                    .refreshToken(refreshToken)
                    .username(user.getUsername())
                    .email(user.getEmail())
                    .role(user.getRole().name())
                    .expiresIn(86400000L) // 24 hours
                    .build();
        } catch (Exception e) {
            System.out.println("Authentication failed: " + e.getClass().getName() + " - " + e.getMessage());
            throw new RuntimeException("Invalid username/email or password", e);
        }
    }
    
    public AuthResponse refreshToken(String refreshToken) {
        try {
            System.out.println("AuthService.refreshToken called with token: " + refreshToken);
            
            String username = jwtUtil.extractUsername(refreshToken);
            System.out.println("Extracted username: " + username);
            
            UserDetails userDetails = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            
            System.out.println("User found: " + userDetails.getUsername());
            
            if (jwtUtil.isTokenValid(refreshToken, userDetails)) {
                System.out.println("Token is valid, generating new tokens");
                String newAccessToken = jwtUtil.generateToken(userDetails);
                String newRefreshToken = jwtUtil.generateRefreshToken(userDetails);
                
                User user = (User) userDetails;
                return AuthResponse.builder()
                        .accessToken(newAccessToken)
                        .refreshToken(newRefreshToken)
                        .username(user.getUsername())
                        .email(user.getEmail())
                        .role(user.getRole().name())
                        .expiresIn(86400000L) // 24 hours
                        .build();
            } else {
                System.out.println("Token is invalid");
                throw new RuntimeException("Invalid refresh token");
            }
        } catch (Exception e) {
            System.out.println("Refresh token error: " + e.getClass().getName() + " - " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Invalid refresh token");
        }
    }
}
