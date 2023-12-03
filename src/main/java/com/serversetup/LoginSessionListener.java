package com.serversetup;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebListener
public class LoginSessionListener implements HttpSessionAttributeListener, HttpSessionListener {

	private static final Logger logger = LogManager.getLogger(LoginSessionListener.class);

	@Override
	public void attributeAdded(HttpSessionBindingEvent event) {
		if ("username".equals(event.getName())) {
			String username = (String) event.getValue();
			logLoginEvent(username, "LOGIN", null, "INFO");
		}
	}

	@Override
	public void attributeRemoved(HttpSessionBindingEvent event) {
		if ("username".equals(event.getName())) {
			String username = (String) event.getValue();
			logLoginEvent(username, "LOGOUT", null, "INFO");
		}
	}

	private static void logLoginEvent(String username, String event, String userAgent, String logLevel) {
		switch (logLevel.toUpperCase()) {
		case "DEBUG":
			logger.debug("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
			break;
		case "INFO":
			logger.info("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
			break;
		case "WARN":
			logger.warn("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
			break;
		case "ERROR":
			logger.error("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
			break;
		case "FATAL":
			logger.fatal("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
			break;
		default:
			logger.info("User: {} - Event: {} - User Agent: {}", username, event, userAgent);
		}
	}
}
