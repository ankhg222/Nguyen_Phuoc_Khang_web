package vn.iot.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import vn.iot.entity.Product;
import vn.iot.entity.UserInfo;
import vn.iot.repository.ProductRepository;
import vn.iot.repository.UserInfoRepository;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserInfoRepository userInfoRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        // Tạo user admin mẫu
        if (!userInfoRepository.findByName("admin").isPresent()) {
            UserInfo admin = new UserInfo();
            admin.setName("admin");
            admin.setUsername("admin");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setEmail("admin@demo.com");
            admin.setRoles("ROLE_ADMIN");
            userInfoRepository.save(admin);
            System.out.println("Created admin user: admin/admin123");
        }

        // Tạo user thường mẫu
        if (!userInfoRepository.findByName("user").isPresent()) {
            UserInfo user = new UserInfo();
            user.setName("user");
            user.setUsername("user");
            user.setPassword(passwordEncoder.encode("user123"));
            user.setEmail("user@demo.com");
            user.setRoles("ROLE_USER");
            userInfoRepository.save(user);
            System.out.println("Created regular user: user/user123");
        }

        // Tạo user demo khác
        if (!userInfoRepository.findByName("demo").isPresent()) {
            UserInfo demo = new UserInfo();
            demo.setName("demo");
            demo.setUsername("demo");
            demo.setPassword(passwordEncoder.encode("demo123"));
            demo.setEmail("demo@demo.com");
            demo.setRoles("ROLE_USER");
            userInfoRepository.save(demo);
            System.out.println("Created demo user: demo/demo123");
        }

        // Tạo sản phẩm mẫu
        createSampleProducts();

        System.out.println("Data initialization completed!");
    }

    private void createSampleProducts() {
        if (productRepository.count() == 0) {
            // Sản phẩm 1
            Product product1 = new Product();
            product1.setName("iPhone 15 Pro");
            product1.setBrand("Apple");
            product1.setMadein("USA");
            product1.setPrice(29990000f);
            productRepository.save(product1);

            // Sản phẩm 2
            Product product2 = new Product();
            product2.setName("Samsung Galaxy S24 Ultra");
            product2.setBrand("Samsung");
            product2.setMadein("South Korea");
            product2.setPrice(27990000f);
            productRepository.save(product2);

            // Sản phẩm 3
            Product product3 = new Product();
            product3.setName("MacBook Pro M3");
            product3.setBrand("Apple");
            product3.setMadein("USA");
            product3.setPrice(45990000f);
            productRepository.save(product3);

            System.out.println("Created sample products");
        }
    }
}
