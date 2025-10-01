package vn.iot.service;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import vn.iot.entity.UserInfo;
import vn.iot.repository.UserInfoRepository;
import vn.iot.security.UserInfoUserDetails;

import java.util.Optional;

@Service
public class UserInfoService implements UserDetailsService {

    private UserInfoRepository repository;

    public void setRepository(UserInfoRepository repository) {
        this.repository = repository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // Tìm user bằng email trước, nếu không có thì tìm bằng name
        Optional<UserInfo> userInfo = repository.findByEmail(username);
        if (!userInfo.isPresent()) {
            userInfo = repository.findByName(username);
        }
        
        return userInfo.map(UserInfoUserDetails::new)
                .orElseThrow(() -> new UsernameNotFoundException("user not found: " + username));
    }
}