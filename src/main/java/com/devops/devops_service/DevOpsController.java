package com.devops.devops_service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
public class DevOpsController {
    @Autowired
    JwtUtil jwtUtil;

    @PostMapping("/DevOps")
    public ResponseEntity<Map<String,String>> handle(
            @RequestBody Map<String,Object> body) {

        String message = (String) body.get("message");
        String to      = (String) body.get("to");
        String from    = (String) body.get("from");
        Integer ttl    = (Integer) body.get("timeToLifeSec");
        if (message==null||to==null||from==null||ttl==null) {
            return ResponseEntity.badRequest().body(Map.of("error","Payload inválido"));
        }

        String token = jwtUtil.generateToken(to, from);
        HttpHeaders headers = new HttpHeaders();
        headers.add("X-JWT-KWY", token);
        return ResponseEntity
                .ok()
                .headers(headers)
                .body(Map.of("message", "Hello " + to + " your message will be sent"));
    }

    @RequestMapping(
            value = "/DevOps",
            method = {
                    RequestMethod.GET,
                    RequestMethod.PUT,
                    RequestMethod.DELETE,
                    RequestMethod.PATCH,
                    RequestMethod.OPTIONS
            }
    )
    public ResponseEntity<String> methodNotAllowed() {
        return ResponseEntity.status(405).body("ERROR");
    }
}
