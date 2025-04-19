#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>
#include <errno.h>
#include <string.h>
#include <time.h>

// Error codes for better diagnostics
#define ERR_NONE          0  // No error
#define ERR_OPEN_FAILED   1  // Failed to open I2C device
#define ERR_IOCTL_FAILED  2  // Failed to set I2C slave address
#define ERR_READ_FAILED   3  // Read operation failed
#define ERR_WRITE_FAILED  4  // Write operation failed
#define ERR_TIMEOUT       5  // Operation timed out
#define ERR_NO_RESPONSE   6  // Device did not respond

// Initialize a device at address 0x20 - might be needed depending on the device type
int initialize_device_0x20(int fd) {
    unsigned char init_seq[][2] = {
        {0x00, 0xFF},  // Example: Write 0xFF to register 0x00 (configure all pins as inputs)
        {0x01, 0x00},  // Example: Write 0x00 to register 0x01
        {0x02, 0x00}   // Example: Write 0x00 to register 0x02
    };
    int ret;
    
    printf("  INFO: Attempting device initialization sequence...\n");
    
    // Try each initialization command
    for (int i = 0; i < 3; i++) {
        printf("  INFO: Init step %d - Writing 0x%02X to register 0x%02X\n", 
               i+1, init_seq[i][1], init_seq[i][0]);
               
        // Write register address and value
        unsigned char buf[2] = {init_seq[i][0], init_seq[i][1]};
        ret = write(fd, buf, 2);
        
        if (ret < 0) {
            printf("  ERROR: Init write failed: %s\n", strerror(errno));
            return ERR_WRITE_FAILED;
        }
        
        usleep(10000);  // 10ms delay between commands
    }
    
    printf("  INFO: Initialization sequence completed\n");
    return ERR_NONE;
}

int main(void) {
    unsigned char buff[0x10];
    int fd;
    int address = 0;
    int nr_bytes = 0;
    int ret = 0;
    int max_attempts = 20;  // Maximum number of attempts for each device
    int attempts = 0;
    int success_0x75 = 0;   // Separate success flag for device 0x75
    int success_0x20 = 0;   // Separate success flag for device 0x20
    int error_code = ERR_NONE;
    time_t start_time;
  
  printf("I2C Test Program - Starting\n");
  
  // Open I2C device with error checking
  fd = open("/dev/i2c-1", O_RDWR);
  if (fd < 0) {
    printf("ERROR: Failed to open /dev/i2c-1: %s\n", strerror(errno));
    return 1;
  }
  printf("Successfully opened /dev/i2c-1\n");
  
  // Test device at address 0x75
  address = 0x75;
  printf("\n=== Testing device at address 0x%02X ===\n", address);
  attempts = 0;
  success_0x75 = 0;
  error_code = ERR_NONE;
  start_time = time(NULL);
  
  while (attempts < max_attempts) {
    printf("Attempt %d for address 0x%02X...\n", attempts + 1, address);
    
    ret = ioctl(fd, I2C_SLAVE, address);
    if (ret < 0) {
      printf("  ERROR: ioctl failed for 0x%02X: %s (errno=%d)\n", 
             address, strerror(errno), errno);
      error_code = ERR_IOCTL_FAILED;
      attempts++;
      usleep(200000);  // 200ms delay between attempts
      continue;
    }
    
    buff[0] = 0;
    nr_bytes = read(fd, buff, 1);
    
    if (nr_bytes < 0) {
      printf("  ERROR: read failed for 0x%02X: %s (errno=%d)\n", 
             address, strerror(errno), errno);
      error_code = ERR_READ_FAILED;
    } else if (nr_bytes == 0) {
      printf("  INFO: No data received from 0x%02X\n", address);
      error_code = ERR_NO_RESPONSE;
    } else {
      printf("  INFO: Received %d bytes from 0x%02X, value: 0x%02X\n", 
             nr_bytes, address, buff[0]);
      
      if (buff[0] == 0x01) {
        printf("  SUCCESS: Device at 0x%02X responded with expected value 0x01\n", address);
        success_0x75 = 1;
        error_code = ERR_NONE;
        break;
      } else {
        printf("  INFO: Received 0x%02X from 0x%02X, expected 0x01\n", buff[0], address);
      }
    }
    
    attempts++;
    usleep(200000);  // 200ms delay between attempts
    
    // Additional timeout check
    if (time(NULL) - start_time > 10) {  // 10 second timeout
      printf("  ERROR: Timeout after 10 seconds for device 0x%02X\n", address);
      error_code = ERR_TIMEOUT;
      break;
    }
  }
  
  if (!success_0x75) {
    printf("  FAILED: Could not communicate with device at 0x%02X after %d attempts\n", 
           address, attempts);
    printf("  DIAGNOSTIC: Error code=%d (%s)\n", error_code, 
           error_code == ERR_IOCTL_FAILED ? "IOCTL failed" :
           error_code == ERR_READ_FAILED ? "Read failed" :
           error_code == ERR_NO_RESPONSE ? "No response" :
           error_code == ERR_TIMEOUT ? "Timeout" : "Unknown error");
  }
  
  // Test device at address 0x20
  address = 0x20;
  printf("\n=== Testing device at address 0x%02X ===\n", address);
  attempts = 0;
  success_0x20 = 0;
  error_code = ERR_NONE;
  start_time = time(NULL);
  
  while (attempts < max_attempts) {
    printf("Attempt %d for address 0x%02X...\n", attempts + 1, address);
    
    ret = ioctl(fd, I2C_SLAVE, address);
    if (ret < 0) {
      printf("  ERROR: ioctl failed for 0x%02X: %s (errno=%d)\n", 
             address, strerror(errno), errno);
      error_code = ERR_IOCTL_FAILED;
      attempts++;
      usleep(200000);  // 200ms delay between attempts
      continue;
    }
    
    // Every 5 attempts, try initializing the device
    if (attempts % 5 == 0 && attempts > 0) {
      initialize_device_0x20(fd);
      
      // Set slave address again after initialization
      ret = ioctl(fd, I2C_SLAVE, address);
      if (ret < 0) {
        printf("  ERROR: ioctl failed after init: %s\n", strerror(errno));
        error_code = ERR_IOCTL_FAILED;
        attempts++;
        continue;
      }
    }
    
    // Try different approaches for the 0x20 device
    
    // First attempt: standard read
    printf("  INFO: Trying standard read (2 bytes)...\n");
    buff[0] = 0; buff[1] = 0;
    nr_bytes = read(fd, buff, 2);
    
    if (nr_bytes < 0) {
      printf("  ERROR: 2-byte read failed: %s (errno=%d)\n", strerror(errno), errno);
      error_code = ERR_READ_FAILED;
    } else if (nr_bytes == 0) {
      printf("  INFO: No data received from 2-byte read\n");
      error_code = ERR_NO_RESPONSE;
    } else {
      printf("  SUCCESS: Received %d bytes from 0x%02X: 0x%02X 0x%02X\n", 
             nr_bytes, address, buff[0], buff[1]);
      success_0x20 = 1;
      error_code = ERR_NONE;
      break;
    }
    
    // Second attempt: try reading just 1 byte
    printf("  INFO: Trying 1-byte read...\n");
    buff[0] = 0;
    nr_bytes = read(fd, buff, 1);
    
    if (nr_bytes < 0) {
      printf("  ERROR: 1-byte read failed: %s (errno=%d)\n", strerror(errno), errno);
      error_code = ERR_READ_FAILED;
    } else if (nr_bytes > 0) {
      printf("  SUCCESS: Received 1 byte from 0x%02X: 0x%02X\n", address, buff[0]);
      success_0x20 = 1;
      error_code = ERR_NONE;
      break;
    } else {
      printf("  INFO: No data received from 1-byte read\n");
      error_code = ERR_NO_RESPONSE;
    }
    
    // Some I2C devices require register selection before reading
    // Try multiple register addresses
    // Try multiple register addresses
    for (unsigned char reg_addr = 0; reg_addr < 3; reg_addr++) {
      printf("  INFO: Trying write-then-read approach with register 0x%02X...\n", reg_addr);
      buff[0] = reg_addr;  // Try accessing different registers
      ret = write(fd, buff, 1);
      
      if (ret < 0) {
        printf("  ERROR: write to register 0x%02X failed: %s (errno=%d)\n", 
               reg_addr, strerror(errno), errno);
        error_code = ERR_WRITE_FAILED;
      } else {
        // Wait a bit after writing
        usleep(10000);  // 10ms delay
        
        // Now try to read from the device
        memset(buff, 0, sizeof(buff));
        nr_bytes = read(fd, buff, 1);
        
        if (nr_bytes < 0) {
          printf("  ERROR: read after writing to reg 0x%02X failed: %s (errno=%d)\n", 
                 reg_addr, strerror(errno), errno);
          error_code = ERR_READ_FAILED;
        } else if (nr_bytes == 0) {
          printf("  INFO: No data received after writing to reg 0x%02X\n", reg_addr);
          error_code = ERR_NO_RESPONSE;
        } else {
          printf("  SUCCESS: Write-then-read succeeded for reg 0x%02X, value: 0x%02X\n", 
                 reg_addr, buff[0]);
          success_0x20 = 1;
          error_code = ERR_NONE;
          break;  // Break out of the register loop
        }
      }
    }
    
    // If we've succeeded with any register, break out of the main loop
    if (success_0x20) {
      break;
    }
    attempts++;
    usleep(500000);  // 500ms delay between attempt cycles
    
    // Additional timeout check
    if (time(NULL) - start_time > 15) {  // 15 second timeout
      printf("  ERROR: Timeout after 15 seconds\n");
      break;
    }
  }
  
  if (!success_0x20) {
    printf("  FAILED: Could not communicate with device at 0x%02X after %d attempts\n", 
           address, attempts);
    printf("  DIAGNOSTIC: Error code=%d (%s)\n", error_code, 
           error_code == ERR_IOCTL_FAILED ? "IOCTL failed" :
           error_code == ERR_READ_FAILED ? "Read failed" :
           error_code == ERR_WRITE_FAILED ? "Write failed" :
           error_code == ERR_NO_RESPONSE ? "No response" :
           error_code == ERR_TIMEOUT ? "Timeout" : "Unknown error");
  }
  
  // Summary
  printf("\n=== Test Summary ===\n");
  printf("Device 0x75: %s\n", success_0x75 ? "WORKING" : "FAILED");
  printf("Device 0x20: %s\n", success_0x20 ? "WORKING" : "FAILED");
  
  // Clean up
  close(fd);
  printf("I2C test completed.\n");
  // Return 0 only if both devices worked, 1 if only 0x75 worked, 2 if only 0x20 worked, 3 if both failed
  if (success_0x75 && success_0x20) {
    return 0;  // Both devices working
  } else if (success_0x75) {
    return 1;  // Only 0x75 working
  } else if (success_0x20) {
    return 2;  // Only 0x20 working
  } else {
    return 3;  // Both devices failed
  }
}
