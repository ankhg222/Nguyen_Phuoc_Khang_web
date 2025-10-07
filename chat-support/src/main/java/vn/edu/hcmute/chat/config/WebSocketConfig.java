package vn.edu.hcmute.chat.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

/**
 * Cấu hình WebSocket cho ứng dụng chat
 * - EnableWebSocketMessageBroker: Kích hoạt WebSocket message broker
 * - STOMP: Simple Text Oriented Messaging Protocol
 */
@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    /**
     * Cấu hình message broker
     * - /topic: Để broadcast tin nhắn đến nhiều clients (public rooms)
     * - /queue: Để gửi tin nhắn riêng tư (private messages)
     */
    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Kích hoạt simple broker cho các destination prefix
        config.enableSimpleBroker("/topic", "/queue");
        
        // Prefix cho các tin nhắn từ client gửi đến server
        config.setApplicationDestinationPrefixes("/app");
        
        // Prefix cho tin nhắn riêng tư
        config.setUserDestinationPrefix("/user");
    }

    /**
     * Đăng ký STOMP endpoints
     * - /ws: endpoint để client kết nối WebSocket
     * - withSockJS(): fallback option cho browsers không hỗ trợ WebSocket
     */
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws")
                .setAllowedOriginPatterns("*") // Cho phép tất cả origins (chỉ dùng cho development)
                .withSockJS(); // Fallback cho browsers cũ
    }
}