# =============================================
# Script Name: Auto Test Spring Boot JWT App (PowerShell)
# Description: Tự động test các API endpoints của ứng dụng Spring Boot JWT
# Author: SpringBoot_1001 Team
# Created: 2025-01-01
# =============================================

param(
    [string]$BaseUrl = "http://localhost:8080",
    [switch]$Help,
    [switch]$Verbose
)

# Colors for output
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

# Test results
$script:TotalTests = 0
$script:PassedTests = 0
$script:FailedTests = 0

# Function to print colored output
function Write-Status {
    param(
        [string]$Status,
        [string]$Message
    )
    
    switch ($Status) {
        "INFO" { Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue }
        "SUCCESS" { Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green }
        "ERROR" { Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red }
        "WARNING" { Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow }
    }
}

# Function to make HTTP request and check response
function Test-Endpoint {
    param(
        [string]$Method,
        [string]$Url,
        [string]$Data = $null,
        [int]$ExpectedStatus,
        [string]$Description,
        [hashtable]$Headers = @{}
    )
    
    $script:TotalTests++
    
    Write-Status "INFO" "Testing: $Description"
    Write-Status "INFO" "URL: $Method $Url"
    
    try {
        # Prepare request parameters
        $requestParams = @{
            Uri = $Url
            Method = $Method
            UseBasicParsing = $true
        }
        
        # Add headers
        if ($Headers.Count -gt 0) {
            $requestParams.Headers = $Headers
        }
        
        # Add body for POST requests
        if ($Method -eq "POST" -and $Data) {
            $requestParams.Body = $Data
            $requestParams.ContentType = "application/json"
        }
        
        # Make request
        $response = Invoke-WebRequest @requestParams -ErrorAction Stop
        
        # Check status code
        if ($response.StatusCode -eq $ExpectedStatus) {
            Write-Status "SUCCESS" "✓ $Description - Status: $($response.StatusCode)"
            $script:PassedTests++
            return $true
        } else {
            Write-Status "ERROR" "✗ $Description - Expected: $ExpectedStatus, Got: $($response.StatusCode)"
            Write-Status "ERROR" "Response: $($response.Content)"
            $script:FailedTests++
            return $false
        }
    }
    catch {
        Write-Status "ERROR" "✗ $Description - Exception: $($_.Exception.Message)"
        $script:FailedTests++
        return $false
    }
}

# Function to extract JWT token from JSON response
function Get-JwtToken {
    param([string]$JsonResponse)
    
    try {
        $responseObj = $JsonResponse | ConvertFrom-Json
        return $responseObj.accessToken
    }
    catch {
        return $null
    }
}

# Function to check if application is running
function Test-AppRunning {
    Write-Status "INFO" "Checking if application is running..."
    
    try {
        $response = Invoke-WebRequest -Uri "$BaseUrl/api/test/public" -UseBasicParsing -ErrorAction Stop
        
        if ($response.StatusCode -eq 200) {
            Write-Status "SUCCESS" "Application is running on $BaseUrl"
            return $true
        } else {
            Write-Status "ERROR" "Application returned status code: $($response.StatusCode)"
            return $false
        }
    }
    catch {
        Write-Status "ERROR" "Application is not running on $BaseUrl"
        Write-Status "ERROR" "Please start the application with: mvn spring-boot:run"
        return $false
    }
}

# Function to show help
function Show-Help {
    Write-Host "Spring Boot JWT Application Test Script (PowerShell)" -ForegroundColor $Colors.Green
    Write-Host ""
    Write-Host "Usage: .\test_app.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  -BaseUrl <url>    Base URL (default: http://localhost:8080)"
    Write-Host "  -Help            Show this help message"
    Write-Host "  -Verbose         Verbose output"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\test_app.ps1                           # Run tests with default settings"
    Write-Host "  .\test_app.ps1 -BaseUrl http://localhost:9090  # Run tests on different port"
    Write-Host ""
}

# Main test function
function Start-Tests {
    Write-Status "INFO" "Starting Spring Boot JWT Application Tests"
    Write-Status "INFO" "=========================================="
    
    # Check if app is running
    if (-not (Test-AppRunning)) {
        exit 1
    }
    
    Write-Status "INFO" ""
    Write-Status "INFO" "1. Testing Public Endpoints"
    Write-Status "INFO" "=========================="
    
    # Test public endpoints
    Test-Endpoint "GET" "$BaseUrl/api/test/public" $null 200 "Public endpoint access"
    Test-Endpoint "GET" "$BaseUrl/api/auth/public/health" $null 200 "Health check endpoint"
    
    Write-Status "INFO" ""
    Write-Status "INFO" "2. Testing Authentication Endpoints"
    Write-Status "INFO" "=================================="
    
    # Test registration
    $timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeSeconds()
    $registerData = @{
        username = "autotest$timestamp"
        email = "autotest$timestamp@example.com"
        password = "password123"
    } | ConvertTo-Json
    
    try {
        $registerResponse = Invoke-WebRequest -Uri "$BaseUrl/api/auth/register" -Method POST -Body $registerData -ContentType "application/json" -UseBasicParsing
        Write-Status "SUCCESS" "✓ User registration successful"
        $script:PassedTests++
    }
    catch {
        Write-Status "ERROR" "✗ User registration failed: $($_.Exception.Message)"
        $script:FailedTests++
    }
    $script:TotalTests++
    
    # Test login with existing user
    $loginData = @{
        usernameOrEmail = "admin"
        password = "admin123"
    } | ConvertTo-Json
    
    try {
        $loginResponse = Invoke-WebRequest -Uri "$BaseUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -UseBasicParsing
        Write-Status "SUCCESS" "✓ Admin login successful"
        $script:PassedTests++
        
        # Extract JWT token
        $jwtToken = Get-JwtToken $loginResponse.Content
        if ($jwtToken) {
            Write-Status "SUCCESS" "✓ JWT token extracted successfully"
            $script:PassedTests++
            
            Write-Status "INFO" ""
            Write-Status "INFO" "3. Testing Protected Endpoints"
            Write-Status "INFO" "=============================="
            
            # Test protected endpoints with JWT token
            $authHeaders = @{ "Authorization" = "Bearer $jwtToken" }
            Test-Endpoint "GET" "$BaseUrl/api/test/protected" $null 200 "Protected endpoint access" $authHeaders
            Test-Endpoint "GET" "$BaseUrl/api/test/admin" $null 200 "Admin endpoint access" $authHeaders
            
        } else {
            Write-Status "ERROR" "✗ Failed to extract JWT token"
            $script:FailedTests++
        }
    }
    catch {
        Write-Status "ERROR" "✗ Admin login failed: $($_.Exception.Message)"
        $script:FailedTests++
    }
    $script:TotalTests++
    
    Write-Status "INFO" ""
    Write-Status "INFO" "4. Testing Error Cases"
    Write-Status "INFO" "====================="
    
    # Test unauthorized access
    Test-Endpoint "GET" "$BaseUrl/api/test/protected" $null 403 "Unauthorized access to protected endpoint"
    
    # Test invalid login
    $invalidLoginData = @{
        usernameOrEmail = "admin"
        password = "wrongpassword"
    } | ConvertTo-Json
    Test-Endpoint "POST" "$BaseUrl/api/auth/login" $invalidLoginData 401 "Login with wrong password"
    
    # Test duplicate registration
    $duplicateData = @{
        username = "admin"
        email = "admin@example.com"
        password = "password123"
    } | ConvertTo-Json
    Test-Endpoint "POST" "$BaseUrl/api/auth/register" $duplicateData 400 "Register with existing username"
    
    Write-Status "INFO" ""
    Write-Status "INFO" "5. Testing Sample Users"
    Write-Status "INFO" "======================"
    
    # Test login with sample users
    $sampleUsers = @(
        @{ username = "test"; password = "test123" },
        @{ username = "newuser123"; password = "password123" },
        @{ username = "testuser4"; password = "password123" }
    )
    
    foreach ($user in $sampleUsers) {
        $loginData = @{
            usernameOrEmail = $user.username
            password = $user.password
        } | ConvertTo-Json
        
        try {
            $loginResponse = Invoke-WebRequest -Uri "$BaseUrl/api/auth/login" -Method POST -Body $loginData -ContentType "application/json" -UseBasicParsing
            Write-Status "SUCCESS" "✓ Login successful for user: $($user.username)"
            $script:PassedTests++
        }
        catch {
            Write-Status "ERROR" "✗ Login failed for user: $($user.username)"
            $script:FailedTests++
        }
        $script:TotalTests++
    }
    
    # Print final results
    Write-Status "INFO" ""
    Write-Status "INFO" "=========================================="
    Write-Status "INFO" "TEST RESULTS SUMMARY"
    Write-Status "INFO" "=========================================="
    Write-Status "INFO" "Total Tests: $script:TotalTests"
    Write-Status "SUCCESS" "Passed: $script:PassedTests"
    Write-Status "ERROR" "Failed: $script:FailedTests"
    
    $successRate = [math]::Round(($script:PassedTests * 100 / $script:TotalTests), 2)
    Write-Status "INFO" "Success Rate: $successRate%"
    
    if ($script:FailedTests -eq 0) {
        Write-Status "SUCCESS" "🎉 All tests passed!"
        exit 0
    } else {
        Write-Status "ERROR" "❌ Some tests failed!"
        exit 1
    }
}

# Main execution
if ($Help) {
    Show-Help
    exit 0
}

# Set verbose mode if requested
if ($Verbose) {
    $VerbosePreference = "Continue"
}

# Run the tests
Start-Tests
