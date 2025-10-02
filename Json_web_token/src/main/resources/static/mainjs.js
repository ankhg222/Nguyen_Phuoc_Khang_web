window.API = (() => {
    const base = "";
    const API_TIMEOUT = 10000; // 10 seconds

    async function request(path, opts = {}, withAuth = true) {
        const controller = new AbortController();
        const timeoutId = setTimeout(() => controller.abort(), API_TIMEOUT);

        const headers = {
            "Content-Type": "application/json",
            ...(opts.headers || {}),
        };

        if (withAuth) {
            const token = localStorage.getItem("accessToken");
            if (token) {
                headers["Authorization"] = `Bearer ${token}`;
            }
        }

        try {
            const res = await fetch(base + path, { 
                ...opts, 
                headers,
                signal: controller.signal
            });
            
            clearTimeout(timeoutId);
            
            const text = await res.text();
            
            if (!res.ok) {
                // Try to parse error response as JSON
                let errorMessage = text || `${res.status} ${res.statusText}`;
                try {
                    const errorData = JSON.parse(text);
                    errorMessage = errorData.message || errorData.error || errorMessage;
                } catch {
                    // Keep original error message if not JSON
                }
                throw new Error(errorMessage);
            }

            try {
                return JSON.parse(text);
            } catch {
                return text;
            }
        } catch (error) {
            clearTimeout(timeoutId);
            
            if (error.name === 'AbortError') {
                throw new Error('Request timeout - please try again');
            }
            
            if (error.message.includes('Failed to fetch')) {
                throw new Error('Network error - please check your connection');
            }
            
            throw error;
        }
    }

    return {
        login: async (body) => {
            try {
                return await request(
                    "/api/auth/login",
                    { method: "POST", body: JSON.stringify(body) },
                    false
                );
            } catch (error) {
                throw new Error(`Login failed: ${error.message}`);
            }
        },

        register: async (body) => {
            try {
                return await request(
                    "/api/auth/register",
                    { method: "POST", body: JSON.stringify(body) },
                    false
                );
            } catch (error) {
                throw new Error(`Registration failed: ${error.message}`);
            }
        },

        refresh: async (refreshToken) => {
            try {
                return await request(
                    "/api/auth/refresh",
                    { method: "POST", body: JSON.stringify({ refreshToken }) },
                    false
                );
            } catch (error) {
                throw new Error(`Token refresh failed: ${error.message}`);
            }
        },

        get: async (path, auth = true) => {
            try {
                return await request(path, { method: "GET" }, auth);
            } catch (error) {
                if (error.message.includes('401') || error.message.includes('403')) {
                    // Token might be expired, try to refresh
                    const refreshToken = localStorage.getItem("refreshToken");
                    if (refreshToken && auth) {
                        try {
                            const newTokens = await this.refresh(refreshToken);
                            localStorage.setItem("accessToken", newTokens.accessToken);
                            localStorage.setItem("refreshToken", newTokens.refreshToken);
                            
                            // Retry the original request
                            return await request(path, { method: "GET" }, auth);
                        } catch (refreshError) {
                            // Refresh failed, redirect to login
                            localStorage.clear();
                            window.location.href = "/login.html";
                            throw new Error("Session expired. Please login again.");
                        }
                    }
                }
                throw error;
            }
        },

        post: async (path, body, auth = true) => {
            try {
                return await request(
                    path, 
                    { method: "POST", body: JSON.stringify(body) }, 
                    auth
                );
            } catch (error) {
                throw new Error(`POST request failed: ${error.message}`);
            }
        },

        put: async (path, body, auth = true) => {
            try {
                return await request(
                    path, 
                    { method: "PUT", body: JSON.stringify(body) }, 
                    auth
                );
            } catch (error) {
                throw new Error(`PUT request failed: ${error.message}`);
            }
        },

        delete: async (path, auth = true) => {
            try {
                return await request(path, { method: "DELETE" }, auth);
            } catch (error) {
                throw new Error(`DELETE request failed: ${error.message}`);
            }
        },

        // Utility functions
        isAuthenticated: () => {
            const token = localStorage.getItem("accessToken");
            if (!token) return false;
            
            try {
                // Check if token is expired (basic check)
                const payload = JSON.parse(atob(token.split('.')[1]));
                const now = Math.floor(Date.now() / 1000);
                return payload.exp > now;
            } catch {
                return false;
            }
        },

        getTokenInfo: () => {
            const token = localStorage.getItem("accessToken");
            if (!token) return null;
            
            try {
                const payload = JSON.parse(atob(token.split('.')[1]));
                return {
                    username: payload.sub,
                    exp: payload.exp,
                    iat: payload.iat,
                    expiresIn: payload.exp - Math.floor(Date.now() / 1000)
                };
            } catch {
                return null;
            }
        },

        logout: () => {
            localStorage.clear();
            window.location.href = "/login.html";
        }
    };
})();

// Global error handler
window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled promise rejection:', event.reason);
    
    // Show user-friendly error message
    if (event.reason && event.reason.message) {
        const errorMessage = event.reason.message;
        if (errorMessage.includes('401') || errorMessage.includes('403')) {
            // Authentication error
            if (confirm('Your session has expired. Would you like to login again?')) {
                window.location.href = "/login.html";
            }
        }
    }
});

// Network status monitoring
window.addEventListener('online', () => {
    console.log('Network connection restored');
});

window.addEventListener('offline', () => {
    console.log('Network connection lost');
    alert('You are offline. Some features may not work properly.');
});