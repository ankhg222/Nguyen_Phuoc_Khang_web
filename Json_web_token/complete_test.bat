@echo off
REM =============================================
REM Script Name: Complete Test Spring Boot JWT App
REM Description: Script test toàn diện cho đồ án Spring Boot JWT
REM Author: SpringBoot_1001 Team
REM Created: 2025-01-01
REM =============================================

echo ============================================
echo COMPLETE TEST SPRING BOOT JWT APPLICATION
echo ============================================
echo.

REM Colors
set "GREEN=[92m"
set "RED=[91m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "RESET=[0m"

REM Test results
set /a TOTAL_TESTS=0
set /a PASSED_TESTS=0
set /a FAILED_TESTS=0

REM Function to print colored output
:print_status
set "status=%1"
set "message=%2"
if "%status%"=="SUCCESS" (
    echo %GREEN%[SUCCESS]%RESET% %message%
) else if "%status%"=="ERROR" (
    echo %RED%[ERROR]%RESET% %message%
) else if "%status%"=="INFO" (
    echo %BLUE%[INFO]%RESET% %message%
) else if "%status%"=="WARNING" (
    echo %YELLOW%[WARNING]%RESET% %message%
)
goto :eof

REM Function to test endpoint
:test_endpoint
set "url=%1"
set "description=%2"
set "expected_status=%3"

set /a TOTAL_TESTS+=1
call :print_status "INFO" "Testing: %description%"

curl -s -o nul -w "%%{http_code}" "%url%" > temp_status.txt
set /p status=<temp_status.txt
del temp_status.txt

if "%status%"=="%expected_status%" (
    call :print_status "SUCCESS" "✓ %description% - Status: %status%"
    set /a PASSED_TESTS+=1
) else (
    call :print_status "ERROR" "✗ %description% - Expected: %expected_status%, Got: %status%"
    set /a FAILED_TESTS+=1
)
goto :eof

echo %BLUE%[INFO]%RESET% Starting comprehensive test...
echo.

REM ============================================
REM PHASE 1: ENVIRONMENT CHECK
REM ============================================
echo %YELLOW%[PHASE 1]%RESET% Environment Check
echo ============================================

REM Check if application is running
call :print_status "INFO" "Checking if application is running..."
curl -s -o nul -w "%%{http_code}" http://localhost:8080/api/test/public > temp_status.txt
set /p app_status=<temp_status.txt
del temp_status.txt

if "%app_status%"=="200" (
    call :print_status "SUCCESS" "Application is running on http://localhost:8080"
) else (
    call :print_status "ERROR" "Application is not running on http://localhost:8080"
    call :print_status "ERROR" "Please start the application with: mvn spring-boot:run"
    pause
    exit /b 1
)

REM Check database connection
call :print_status "INFO" "Checking database connection..."
sqlcmd -S localhost -U sa -P 1 -Q "SELECT COUNT(*) FROM users" -h -1 > nul 2>&1
if %errorlevel%==0 (
    call :print_status "SUCCESS" "Database connection successful"
) else (
    call :print_status "ERROR" "Database connection failed"
    call :print_status "ERROR" "Please check SQL Server and run complete_database_setup.sql"
)

echo.

REM ============================================
REM PHASE 2: FRONTEND TESTS
REM ============================================
echo %YELLOW%[PHASE 2]%RESET% Frontend Tests
echo ============================================

call :test_endpoint "http://localhost:8080/" "Home page" "200"
call :test_endpoint "http://localhost:8080/index.html" "Index page" "200"
call :test_endpoint "http://localhost:8080/login.html" "Login page" "200"
call :test_endpoint "http://localhost:8080/dashboard.html" "Dashboard page" "200"
call :test_endpoint "http://localhost:8080/profile.html" "Profile page" "200"
call :test_endpoint "http://localhost:8080/mainjs.js" "JavaScript file" "200"

echo.

REM ============================================
REM PHASE 3: API TESTS
REM ============================================
echo %YELLOW%[PHASE 3]%RESET% API Tests
echo ============================================

call :test_endpoint "http://localhost:8080/api/test/public" "Public API" "200"
call :test_endpoint "http://localhost:8080/api/auth/public/health" "Health check" "200"
call :test_endpoint "http://localhost:8080/api/test/user" "Protected API (no auth)" "403"

echo.

REM ============================================
REM PHASE 4: AUTHENTICATION TESTS
REM ============================================
echo %YELLOW%[PHASE 4]%RESET% Authentication Tests
echo ============================================

REM Test admin login
call :print_status "INFO" "Testing admin login..."
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"admin\",\"password\":\"admin123\"}" http://localhost:8080/api/auth/login > login_response.json 2>nul
if %errorlevel%==0 (
    call :print_status "SUCCESS" "✓ Admin login successful"
    set /a PASSED_TESTS+=1
) else (
    call :print_status "ERROR" "✗ Admin login failed"
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test test user login
call :print_status "INFO" "Testing test user login..."
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"test\",\"password\":\"test123\"}" http://localhost:8080/api/auth/login > nul 2>&1
if %errorlevel%==0 (
    call :print_status "SUCCESS" "✓ Test user login successful"
    set /a PASSED_TESTS+=1
) else (
    call :print_status "ERROR" "✗ Test user login failed"
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

REM Test wrong password
call :print_status "INFO" "Testing wrong password..."
curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"admin\",\"password\":\"wrongpassword\"}" http://localhost:8080/api/auth/login > nul 2>&1
if %errorlevel%==0 (
    call :print_status "ERROR" "✗ Wrong password should fail"
    set /a FAILED_TESTS+=1
) else (
    call :print_status "SUCCESS" "✓ Wrong password correctly rejected"
    set /a PASSED_TESTS+=1
)
set /a TOTAL_TESTS+=1

echo.

REM ============================================
REM PHASE 5: JWT TOKEN TESTS
REM ============================================
echo %YELLOW%[PHASE 5]%RESET% JWT Token Tests
echo ============================================

REM Extract JWT token
call :print_status "INFO" "Extracting JWT token..."
powershell -Command "try { $response = Get-Content 'login_response.json' | ConvertFrom-Json; $token = $response.accessToken; if ($token) { Set-Content 'jwt_token.txt' $token; Write-Host 'JWT token extracted successfully' } else { Write-Host 'Failed to extract JWT token' } } catch { Write-Host 'Failed to parse login response' }" > nul 2>&1

if exist jwt_token.txt (
    call :print_status "SUCCESS" "✓ JWT token extracted successfully"
    set /a PASSED_TESTS+=1
    
    REM Test protected endpoint with token
    call :print_status "INFO" "Testing protected endpoint with JWT token..."
    set /p jwt_token=<jwt_token.txt
    curl -s -H "Authorization: Bearer %jwt_token%" http://localhost:8080/api/test/user > nul 2>&1
    if %errorlevel%==0 (
        call :print_status "SUCCESS" "✓ Protected endpoint accessible with valid token"
        set /a PASSED_TESTS+=1
    ) else (
        call :print_status "ERROR" "✗ Protected endpoint not accessible with valid token"
        set /a FAILED_TESTS+=1
    )
    set /a TOTAL_TESTS+=1
    
    REM Test admin endpoint
    call :print_status "INFO" "Testing admin endpoint..."
    curl -s -H "Authorization: Bearer %jwt_token%" http://localhost:8080/api/test/admin > nul 2>&1
    if %errorlevel%==0 (
        call :print_status "SUCCESS" "✓ Admin endpoint accessible with admin token"
        set /a PASSED_TESTS+=1
    ) else (
        call :print_status "ERROR" "✗ Admin endpoint not accessible with admin token"
        set /a FAILED_TESTS+=1
    )
    set /a TOTAL_TESTS+=1
) else (
    call :print_status "ERROR" "✗ Failed to extract JWT token"
    set /a FAILED_TESTS+=1
)
set /a TOTAL_TESTS+=1

echo.

REM ============================================
REM PHASE 6: SAMPLE USERS TESTS
REM ============================================
echo %YELLOW%[PHASE 6]%RESET% Sample Users Tests
echo ============================================

REM Test all sample users
set "users=test:test123 newuser123:password123 testuser4:password123"
for %%u in (%users%) do (
    for /f "tokens=1,2 delims=:" %%a in ("%%u") do (
        call :print_status "INFO" "Testing user: %%a"
        curl -s -X POST -H "Content-Type: application/json" -d "{\"usernameOrEmail\":\"%%a\",\"password\":\"%%b\"}" http://localhost:8080/api/auth/login > nul 2>&1
        if !errorlevel!==0 (
            call :print_status "SUCCESS" "✓ Login successful for user: %%a"
            set /a PASSED_TESTS+=1
        ) else (
            call :print_status "ERROR" "✗ Login failed for user: %%a"
            set /a FAILED_TESTS+=1
        )
        set /a TOTAL_TESTS+=1
    )
)

echo.

REM ============================================
REM PHASE 7: PERFORMANCE TESTS
REM ============================================
echo %YELLOW%[PHASE 7]%RESET% Performance Tests
echo ============================================

REM Test response time
call :print_status "INFO" "Testing response time..."
powershell -Command "$start = Get-Date; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/test/public' -UseBasicParsing; $end = Get-Date; $duration = ($end - $start).TotalMilliseconds; if ($duration -lt 500) { Write-Host 'Response time: ' $duration 'ms - GOOD' } else { Write-Host 'Response time: ' $duration 'ms - SLOW' } } catch { Write-Host 'Performance test failed' }"

echo.

REM ============================================
REM FINAL RESULTS
REM ============================================
echo ============================================
echo %BLUE%[FINAL RESULTS]%RESET%
echo ============================================
echo %BLUE%[INFO]%RESET% Total Tests: %TOTAL_TESTS%
echo %GREEN%[SUCCESS]%RESET% Passed: %PASSED_TESTS%
echo %RED%[ERROR]%RESET% Failed: %FAILED_TESTS%

set /a success_rate=(%PASSED_TESTS% * 100) / %TOTAL_TESTS%
echo %BLUE%[INFO]%RESET% Success Rate: %success_rate%%%

if %FAILED_TESTS%==0 (
    echo.
    echo %GREEN%[SUCCESS]%RESET% 🎉 ALL TESTS PASSED!
    echo %GREEN%[SUCCESS]%RESET% Your Spring Boot JWT application is working perfectly!
    echo.
    echo %BLUE%[INFO]%RESET% You can now:
    echo %BLUE%[INFO]%RESET% - Open http://localhost:8080/ in your browser
    echo %BLUE%[INFO]%RESET% - Login with admin/admin123 or test/test123
    echo %BLUE%[INFO]%RESET% - Explore the dashboard and profile pages
    echo %BLUE%[INFO]%RESET% - Test the API endpoints
) else (
    echo.
    echo %RED%[ERROR]%RESET% ❌ SOME TESTS FAILED!
    echo %RED%[ERROR]%RESET% Please check the errors above and fix them.
)

echo.
echo ============================================
echo Test completed at %date% %time%
echo ============================================

REM Cleanup
if exist login_response.json del login_response.json
if exist jwt_token.txt del jwt_token.txt
if exist temp_status.txt del temp_status.txt

echo.
pause
