package vn.hcmute.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import vn.hcmute.dto.AuthRequest;
import vn.hcmute.dto.LoginRequest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
public class AuthControllerTest {
    
    @Autowired
    private WebApplicationContext webApplicationContext;
    
    private MockMvc mockMvc;
    
    @Autowired
    private ObjectMapper objectMapper;
    
    public void setup() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
    }
    
    @Test
    public void testHealthEndpoint() throws Exception {
        setup();
        mockMvc.perform(get("/api/auth/public/health"))
                .andExpect(status().isOk())
                .andExpect(content().string("Auth service is running!"));
    }
    
    @Test
    public void testPublicEndpoint() throws Exception {
        setup();
        mockMvc.perform(get("/api/test/public"))
                .andExpect(status().isOk())
                .andExpect(content().string("This is a public endpoint - no authentication required!"));
    }
    
    @Test
    public void testRegisterUser() throws Exception {
        setup();
        AuthRequest authRequest = new AuthRequest();
        authRequest.setUsername("testuser");
        authRequest.setEmail("test@example.com");
        authRequest.setPassword("password123");
        
        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(authRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("testuser"))
                .andExpect(jsonPath("$.email").value("test@example.com"))
                .andExpect(jsonPath("$.accessToken").exists())
                .andExpect(jsonPath("$.refreshToken").exists());
    }
    
    @Test
    public void testLoginUser() throws Exception {
        setup();
        // First register a user
        AuthRequest authRequest = new AuthRequest();
        authRequest.setUsername("logintest");
        authRequest.setEmail("logintest@example.com");
        authRequest.setPassword("password123");
        
        mockMvc.perform(post("/api/auth/register")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(authRequest)));
        
        // Then login
        LoginRequest loginRequest = new LoginRequest();
        loginRequest.setUsernameOrEmail("logintest");
        loginRequest.setPassword("password123");
        
        mockMvc.perform(post("/api/auth/login")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("logintest"))
                .andExpect(jsonPath("$.accessToken").exists())
                .andExpect(jsonPath("$.refreshToken").exists());
    }
}
