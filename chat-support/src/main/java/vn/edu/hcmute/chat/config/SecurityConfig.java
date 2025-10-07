package vn.edu.hcmute.chat.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

/**
 * Cấu hình bảo mật cho ứng dụng
 * Tạm thời disable security để dễ dàng test WebSocket
 */
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // Disable CSRF cho WebSocket
            .authorizeHttpRequests(authz -> authz
                .anyRequest().permitAll() // Cho phép tất cả requests (chỉ dùng cho demo)
            )
            .headers(headers -> headers
                .frameOptions(frame -> frame.sameOrigin()) // Cho phép iframe từ same origin
            );
        
        return http.build();
    }
}