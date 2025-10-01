package vn.iot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import vn.iot.entity.UserInfo;
import vn.iot.repository.UserInfoRepository;
import vn.iot.service.ProductService;

import java.util.List;

@Controller
@RequestMapping("/jsp")
public class JspController {

    @Autowired
    private ProductService productService;

    @Autowired
    private UserInfoRepository userInfoRepository;

    @GetMapping("")
    public String jspHome(Model model) {
        List<vn.iot.entity.Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "index";
    }

    @GetMapping("/login")
    public String jspLogin() {
        return "login";
    }

    @GetMapping("/register")
    public String jspRegister(Model model) {
        model.addAttribute("user", new UserInfo());
        return "register";
    }

    @PostMapping("/register")
    public String jspRegisterSubmit(@ModelAttribute UserInfo user) {
        // Set default role
        user.setRoles("ROLE_USER");
        userInfoRepository.save(user);
        return "redirect:/jsp/login?registered=true";
    }

    @GetMapping("/customer")
    public String jspCustomer(Model model) {
        List<UserInfo> users = userInfoRepository.findAll();
        model.addAttribute("users", users);
        return "customer";
    }

    @GetMapping("/products")
    public String jspProducts(Model model) {
        List<vn.iot.entity.Product> products = productService.getAllProducts();
        model.addAttribute("products", products);
        return "products";
    }

    @GetMapping("/summary")
    public String jspSummary() {
        return "summary";
    }

    @GetMapping("/admin")
    public String jspAdmin(Model model) {
        List<UserInfo> users = userInfoRepository.findAll();
        List<vn.iot.entity.Product> products = productService.getAllProducts();
        model.addAttribute("users", users);
        model.addAttribute("products", products);
        return "admin";
    }
}
