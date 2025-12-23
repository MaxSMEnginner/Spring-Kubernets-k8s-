package com.davinchicoder.springk8s.user;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@RequiredArgsConstructor
public class UserSeeder implements CommandLineRunner {

    private final UserRepository userRepository;

    @Override
    public void run(String... args) {

        List<User> users = userRepository.findAll();

        if (users.isEmpty()) {

            userRepository.saveAll(
                    List.of(
                            User.builder().name("John Smith").email("john.smith@gmail.com").password("P@ssw0rd123").role("ADMIN").build(),
                            User.builder().name("Mary Johnson").email("mary.j@company.com").password("SecurePass!99").role("USER").build(),
                            User.builder().name("David Wilson").email("david.wilson@outlook.com").password("MyP@ss2024").role("USER").build(),
                            User.builder().name("Sarah Davis").email("sarah.d@gmail.com").password("S@feP@ss456").role("MANAGER").build(),
                            User.builder().name("Michael Brown").email("mbrown@company.com").password("Br0wnP@ss!").role("USER").build()
                    )
            );

        }

    }
}
