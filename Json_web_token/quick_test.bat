@echo off
REM =============================================
REM Script Name: Quick Test Spring Boot JWT App
REM Description: Script đơn giản để test ứng dụng Spring Boot JWT
REM Author: SpringBoot_1001 Team
REM Created: 2025-01-01
REM =============================================

echo ============================================
echo Spring Boot JWT Application Quick Test
echo ============================================
echo.

REM Check if application is running
echo [INFO] Checking if application is running...
curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/test/public > temp_status.txt
set /p status=<temp_status.txt
del temp_status.txt

if "%status%"=="200" (
    echo [SUCCESS] Application is running on http://localhost:8080
) else (
    echo [ERROR] Application is not running on http://localhost:8080
    echo [ERROR] Please start the application with: mvn spring-boot:run
    pause
    exit /b 1
)

echo.
echo [INFO] Starting tests...
echo.

REM Test 1: Public endpoint
echo [TEST 1] Testing public endpoint...
curl -s http://localhost:8080/api/test/public
echo.
echo.

REM Test 2: Health check
echo [TEST 2] Testing health check...
curl -s http://localhost:8080/api/auth/public/health
echo.
echo.

REM Test 3: Login with admin
echo [TEST 3] Testing admin login...
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"admin\",\"password\":\"admin123\"}" http://localhost:8080/api/auth/login > login_response.json
echo Login response saved to login_response.json
echo.

REM Extract token from response (simple approach)
echo [INFO] Extracting JWT token...
powershell -Command "try { $response = Get-Content 'login_response.json' | ConvertFrom-Json; $token = $response.accessToken; if ($token) { Set-Content 'jwt_token.txt' $token; Write-Host '[SUCCESS] JWT token extracted and saved to jwt_token.txt' } else { Write-Host '[ERROR] Failed to extract JWT token' } } catch { Write-Host '[ERROR] Failed to parse login response' }"

REM Test 4: Protected endpoint (if token exists)
if exist jwt_token.txt (
    echo.
    echo [TEST 4] Testing protected endpoint...
    set /p jwt_token=<jwt_token.txt
    curl -s -H "Authorization: Bearer %jwt_token%" http://localhost:8080/api/test/protected
    echo.
    echo.
    
    echo [TEST 5] Testing admin endpoint...
    curl -s -H "Authorization: Bearer %jwt_token%" http://localhost:8080/api/test/admin
    echo.
    echo.
) else (
    echo [WARNING] Skipping protected endpoint tests - no JWT token available
)

REM Test 6: Unauthorized access
echo [TEST 6] Testing unauthorized access (should return 403)...
curl -s -w "HTTP Status: %%{http_code}" http://localhost:8080/api/test/protected
echo.
echo.

REM Test 7: Wrong password
echo [TEST 7] Testing wrong password (should return 401)...
curl -s -w "HTTP Status: %%{http_code}" -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"admin\",\"password\":\"wrongpassword\"}" http://localhost:8080/api/auth/login
echo.
echo.

REM Test 8: Sample users login
echo [TEST 8] Testing sample users...
echo Testing test user...
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"test\",\"password\":\"test123\"}" http://localhost:8080/api/auth/login > nul
if %errorlevel%==0 (
    echo [SUCCESS] Test user login successful
) else (
    echo [ERROR] Test user login failed
)

echo Testing newuser123...
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"newuser123\",\"password\":\"password123\"}" http://localhost:8080/api/auth/login > nul
if %errorlevel%==0 (
    echo [SUCCESS] newuser123 login successful
) else (
    echo [ERROR] newuser123 login failed
)

echo.
echo ============================================
echo Test completed!
echo ============================================
echo.
echo Files created:
echo - login_response.json (admin login response)
if exist jwt_token.txt echo - jwt_token.txt (JWT token)
echo.
echo To clean up test files, run: del login_response.json jwt_token.txt
echo.

pause
