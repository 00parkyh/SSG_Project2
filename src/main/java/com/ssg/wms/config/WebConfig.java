package com.ssg.wms.config;

import lombok.extern.log4j.Log4j2;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

// [참고] RoleCheckInterceptor와 StatusCheckInterceptor는
// @RequiredArgsConstructor로 주입받는 것이 더 좋습니다.
// (지금은 new()로 생성되어 있으니 그대로 둡니다.)

@Log4j2
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        log.info("addInterceptors 작동");

        registry.addInterceptor(new RoleCheckInterceptor("ADMIN"))
                .addPathPatterns("/admin/**", "/dashboard/**", "/sales/**", "/expense/**");

        registry.addInterceptor(new RoleCheckInterceptor("ADMIN", "MANAGER"))
                .addPathPatterns("/stock/**");

        registry.addInterceptor(new RoleCheckInterceptor("ADMIN", "MANAGER", "MEMBER"))
                .addPathPatterns("/**");


//        // 관리자만 허용 (ADMIN)
//        registry.addInterceptor(new RoleCheckInterceptor("ADMIN"))
//                .addPathPatterns(
//                        "/announcements/save",
//                        "/announcements/*/edit",
//                        "/announcements/*/delete",
//                        "/admin/**",
//                        "*/admin/**",
//
//                        // --- ▼ [신규 추가] 재무관리 페이지 3개 ---
//                        "/dashboard/**",
//                        "/sales/**",
//                        "/expense/**"
//                        // --- ▲ [신규 추가] ---
//                )
//                .excludePathPatterns(
//                        "/admin/login"
//                );
////        // 관리자와 창고관리자 둘 다 허용 (ADMIN, MANAGER)
////        registry.addInterceptor(new RoleCheckInterceptor("ADMIN", "MANAGER"))
////                .addPathPatterns(
////                        // (여기에 향후 공통 페이지 추가, 예: "/stock/**")
////                );
//
//        registry.addInterceptor(new StatusCheckInterceptor("INACTIVE"))
//                .excludePathPatterns(
//                        "*/member/**",
//                        "/member/**"
//                );

    }
}