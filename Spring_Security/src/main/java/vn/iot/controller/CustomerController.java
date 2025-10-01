package vn.iot.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.web.bind.annotation.*;
import vn.iot.entity.Customer;

import java.util.ArrayList;
import java.util.List;

@RestController
@EnableMethodSecurity
public class CustomerController {

    private List<Customer> customers = new ArrayList<>();

    public CustomerController() {
        // Khởi tạo dữ liệu mẫu
        customers.add(new Customer("001", "Nguyễn Hữu Trung", "090861710", "trungnhapkt@gmail.com"));
        customers.add(new Customer("002", "Hữu Trung", "090123456", "trunghun@gmail.com"));
    }

    @GetMapping("/hello")
    public String hello() {
        return "hello is Guest";
    }

    @GetMapping("/customer/all")
    @PreAuthorize("hasAuthority('ROLE_ADMIN')")
    public List<Customer> getCustomerList() {
        return customers;
    }

    @GetMapping("/customer/{id}")
    @PreAuthorize("hasAuthority('ROLE_USER')")
    public Customer getCustomerById(@PathVariable String id) {
        return customers.stream()
                .filter(customer -> customer.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}
