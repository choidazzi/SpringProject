package kr.or.ddit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/error")
@Controller
public class ErrorController {
    @GetMapping("/error400")
    public String error400() {
        return "error/error400";
    }

    @GetMapping("/error404")
    public String error404() {
        return "error/error404";
    }

    @GetMapping("/error500")
    public String error500() {
        return "error/error500";
    }

    @GetMapping("/errorDefault")
    public String errorDeafault() {
        return "error/errorDefault";
    }

}
