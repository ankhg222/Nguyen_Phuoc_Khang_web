#!/bin/bash

# =============================================
# Script Name: Auto Test Spring Boot JWT App
# Description: Tự động test các API endpoints của ứng dụng Spring Boot JWT
# Author: SpringBoot_1001 Team
# Created: 2025-01-01
# =============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BASE_URL="http://localhost:8080"
API_BASE="$BASE_URL/api"
AUTH_BASE="$API_BASE/auth"
TEST_BASE="$API_BASE/test"

# Test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
    esac
}

# Function to make HTTP request and check response
test_endpoint() {
    local method=$1
    local url=$2
    local data=$3
    local expected_status=$4
    local description=$5
    local headers=$6
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    print_status "INFO" "Testing: $description"
    print_status "INFO" "URL: $method $url"
    
    # Build curl command
    local curl_cmd="curl -s -w \"%{http_code}\" -o /tmp/response.json"
    
    if [ ! -z "$headers" ]; then
        curl_cmd="$curl_cmd -H \"$headers\""
    fi
    
    if [ "$method" = "POST" ] && [ ! -z "$data" ]; then
        curl_cmd="$curl_cmd -H \"Content-Type: application/json\" -d '$data'"
    fi
    
    curl_cmd="$curl_cmd -X $method \"$url\""
    
    # Execute request
    local http_code=$(eval $curl_cmd)
    local response=$(cat /tmp/response.json 2>/dev/null || echo "")
    
    # Check result
    if [ "$http_code" = "$expected_status" ]; then
        print_status "SUCCESS" "✓ $description - Status: $http_code"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        return 0
    else
        print_status "ERROR" "✗ $description - Expected: $expected_status, Got: $http_code"
        print_status "ERROR" "Response: $response"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        return 1
    fi
}

# Function to extract JWT token from response
extract_token() {
    local response=$1
    echo "$response" | grep -o '"accessToken":"[^"]*"' | cut -d'"' -f4
}

# Function to check if application is running
check_app_running() {
    print_status "INFO" "Checking if application is running..."
    
    local response=$(curl -s -w "%{http_code}" -o /dev/null "$BASE_URL/api/test/public")
    
    if [ "$response" = "200" ]; then
        print_status "SUCCESS" "Application is running on $BASE_URL"
        return 0
    else
        print_status "ERROR" "Application is not running on $BASE_URL"
        print_status "ERROR" "Please start the application with: mvn spring-boot:run"
        return 1
    fi
}

# Main test function
run_tests() {
    print_status "INFO" "Starting Spring Boot JWT Application Tests"
    print_status "INFO" "=========================================="
    
    # Check if app is running
    if ! check_app_running; then
        exit 1
    fi
    
    print_status "INFO" ""
    print_status "INFO" "1. Testing Public Endpoints"
    print_status "INFO" "=========================="
    
    # Test public endpoints
    test_endpoint "GET" "$TEST_BASE/public" "" "200" "Public endpoint access"
    test_endpoint "GET" "$AUTH_BASE/public/health" "" "200" "Health check endpoint"
    
    print_status "INFO" ""
    print_status "INFO" "2. Testing Authentication Endpoints"
    print_status "INFO" "=================================="
    
    # Test registration
    local register_data='{"username":"autotest'$(date +%s)'","email":"autotest'$(date +%s)'@example.com","password":"password123"}'
    local register_response=$(curl -s -X POST -H "Content-Type: application/json" -d "$register_data" "$AUTH_BASE/register")
    local register_status=$?
    
    if [ $register_status -eq 0 ]; then
        print_status "SUCCESS" "✓ User registration successful"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        print_status "ERROR" "✗ User registration failed"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    # Test login with existing user
    local login_data='{"usernameOrEmail":"admin","password":"admin123"}'
    local login_response=$(curl -s -X POST -H "Content-Type: application/json" -d "$login_data" "$AUTH_BASE/login")
    local login_status=$?
    
    if [ $login_status -eq 0 ]; then
        print_status "SUCCESS" "✓ Admin login successful"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        
        # Extract JWT token
        local jwt_token=$(extract_token "$login_response")
        if [ ! -z "$jwt_token" ]; then
            print_status "SUCCESS" "✓ JWT token extracted successfully"
            PASSED_TESTS=$((PASSED_TESTS + 1))
            
            print_status "INFO" ""
            print_status "INFO" "3. Testing Protected Endpoints"
            print_status "INFO" "=============================="
            
            # Test protected endpoints with JWT token
            test_endpoint "GET" "$TEST_BASE/protected" "" "200" "Protected endpoint access" "Authorization: Bearer $jwt_token"
            test_endpoint "GET" "$TEST_BASE/admin" "" "200" "Admin endpoint access" "Authorization: Bearer $jwt_token"
            
        else
            print_status "ERROR" "✗ Failed to extract JWT token"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
    else
        print_status "ERROR" "✗ Admin login failed"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    print_status "INFO" ""
    print_status "INFO" "4. Testing Error Cases"
    print_status "INFO" "====================="
    
    # Test unauthorized access
    test_endpoint "GET" "$TEST_BASE/protected" "" "403" "Unauthorized access to protected endpoint"
    
    # Test invalid login
    local invalid_login_data='{"usernameOrEmail":"admin","password":"wrongpassword"}'
    test_endpoint "POST" "$AUTH_BASE/login" "$invalid_login_data" "401" "Login with wrong password"
    
    # Test duplicate registration
    local duplicate_data='{"username":"admin","email":"admin@example.com","password":"password123"}'
    test_endpoint "POST" "$AUTH_BASE/register" "$duplicate_data" "400" "Register with existing username"
    
    print_status "INFO" ""
    print_status "INFO" "5. Testing Sample Users"
    print_status "INFO" "======================"
    
    # Test login with sample users
    local sample_users=("test:test123" "newuser123:password123" "testuser4:password123")
    
    for user_pass in "${sample_users[@]}"; do
        local username=$(echo $user_pass | cut -d: -f1)
        local password=$(echo $user_pass | cut -d: -f2)
        
        local login_data="{\"usernameOrEmail\":\"$username\",\"password\":\"$password\"}"
        local login_response=$(curl -s -X POST -H "Content-Type: application/json" -d "$login_data" "$AUTH_BASE/login")
        local login_status=$?
        
        if [ $login_status -eq 0 ]; then
            print_status "SUCCESS" "✓ Login successful for user: $username"
            PASSED_TESTS=$((PASSED_TESTS + 1))
        else
            print_status "ERROR" "✗ Login failed for user: $username"
            FAILED_TESTS=$((FAILED_TESTS + 1))
        fi
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
    done
    
    # Print final results
    print_status "INFO" ""
    print_status "INFO" "=========================================="
    print_status "INFO" "TEST RESULTS SUMMARY"
    print_status "INFO" "=========================================="
    print_status "INFO" "Total Tests: $TOTAL_TESTS"
    print_status "SUCCESS" "Passed: $PASSED_TESTS"
    print_status "ERROR" "Failed: $FAILED_TESTS"
    
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    print_status "INFO" "Success Rate: $success_rate%"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        print_status "SUCCESS" "🎉 All tests passed!"
        exit 0
    else
        print_status "ERROR" "❌ Some tests failed!"
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Spring Boot JWT Application Test Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -u, --url      Base URL (default: http://localhost:8080)"
    echo "  -v, --verbose  Verbose output"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run tests with default settings"
    echo "  $0 -u http://localhost:9090  # Run tests on different port"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -u|--url)
            BASE_URL="$2"
            API_BASE="$BASE_URL/api"
            AUTH_BASE="$API_BASE/auth"
            TEST_BASE="$API_BASE/test"
            shift 2
            ;;
        -v|--verbose)
            set -x
            shift
            ;;
        *)
            print_status "ERROR" "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Run the tests
run_tests
