package com.serversetup;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@WebListener
public class LoginSessionListener implements HttpSessionListener {

	private static final Logger logger = LogManager.getLogger(LoginSessionListener.class);

	@Override
	public void sessionCreated(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		logger.info("Session created - ID: {}", session.getId());
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent se) {
		HttpSession session = se.getSession();
		String username = (String) session.getAttribute("username");

		if (username != null) {
			String userAgent = (String) session.getAttribute("userAgent");
			String userIP = (String) session.getAttribute("userIP");
			logger.info("Session destroyed - User: {} - User Agent: {} - User IP: {}", username, userAgent, userIP);
		}
	}
}
