package com.minitwit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import com.minitwit.config.WebConfig;

@EnableAutoConfiguration
@EnableConfigurationProperties({ ServerProperties.class }) // Use application.yml for config
@Configuration
@ComponentScan({ "com.minitwit" })
public class App {
	
	public static void main(String[] args) {
		SpringApplication app = new SpringApplication(App.class);
		// disable Spring's web server setup - let spark configure jetty
		app.setWebEnvironment(false);

		ConfigurableApplicationContext ctx = app.run(args);
		// initialize web service
		ctx.getBean(WebConfig.class);
		// enable spark graceful shutdown
		ctx.registerShutdownHook();
    }
    
}
