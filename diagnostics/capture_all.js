const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

(async () => {
  console.log('Starting Puppeteer browser...');
  
  // Clean browser launch that matches Flutter run's behavior
  const browser = await puppeteer.launch({
    headless: false,
    // Use full browser (not app mode) with maximized window
    defaultViewport: null,
    ignoreDefaultArgs: ['--enable-automation'],
    args: [
      '--start-maximized',
      '--no-sandbox',
      '--disable-web-security'
    ]
  });
  
  // Create a single page/tab - important to avoid blank tabs
  const pages = await browser.pages();
  const page = pages[0]; // Use the initial page instead of creating new ones
  
  // Initialize data collection
  const consoleMessages = [];
  
  // Capture console messages
  page.on('console', msg => {
    const type = msg.type();
    const text = msg.text();
    const logEntry = `[${type}] ${text}`;
    console.log(logEntry);
    consoleMessages.push(logEntry);
  });

  // Capture network requests
  await page.setRequestInterception(true);
  const requests = {};
  
  page.on('request', request => {
    requests[request.url()] = {
      url: request.url(),
      method: request.method(),
      headers: request.headers(),
      postData: request.postData()
    };
    request.continue();
  });
  
  page.on('response', async response => {
    const url = response.url();
    if (requests[url]) {
      try {
        const responseBody = await response.text();
        requests[url].response = {
          status: response.status(),
          headers: response.headers(),
          body: responseBody
        };
      } catch (error) {
        requests[url].response = {
          status: response.status(),
          headers: response.headers(),
          body: `Error capturing body: ${error.message}`
        };
      }
    }
  });
  
  try {
    // Navigate to the Flutter app
    console.log('Navigating to http://localhost:8888...');
    await page.goto('http://localhost:8888', {
      waitUntil: 'networkidle2',
      timeout: 60000
    });
    
    // Add a minimal, non-interfering test banner
    await page.evaluate(() => {
      // Set page title
      document.title = "Chrome Test Browser - Flutter Testing";
      
// Add a minimal banner at the top that doesn't affect layout
const banner = document.createElement('div');
banner.style.position = 'fixed';
banner.style.top = '0';
banner.style.left = '0';
banner.style.right = '0';
banner.style.padding = '2.5px'; // Reduced padding to half
banner.style.backgroundColor = 'rgba(255, 0, 0, 0.1)'; // 50% opacity
banner.style.color = 'white';
banner.style.zIndex = '2147483647'; // Maximum z-index
banner.style.textAlign = 'center';
banner.style.fontFamily = 'Arial, sans-serif';
banner.style.fontSize = '14px'; // Keep font size the same for consistency, just reduce height.
banner.style.fontWeight = 'bold';
banner.style.pointerEvents = 'none'; // Don't interfere with clicks
banner.textContent = '⚠️ TEST BROWSER - Interact with the app to reproduce issues ⚠️';
document.body.appendChild(banner);
    });
    
    console.log('Test browser is ready. Interact with the app to reproduce issues.');
    console.log('Press Ctrl+C in the terminal when you are done testing.');
    
    // Keep the browser open until the user presses Ctrl+C
    await new Promise(resolve => {
      process.on('SIGINT', async () => {
        console.log('\nReceived Ctrl+C, saving logs and closing browser...');
        resolve();
      });
      
      // Also set a timeout as fallback
      setTimeout(() => {
        console.log('\nTest timeout reached (10 minutes), saving logs and closing browser...');
        resolve();
      }, 10 * 60 * 1000);
    });
    
    // Save diagnostic data
    fs.writeFileSync(
      path.join(__dirname, 'console_log.txt'),
      consoleMessages.join('\n')
    );
    
    fs.writeFileSync(
      path.join(__dirname, 'network_log.json'),
      JSON.stringify(requests, null, 2)
    );
    
    // Create HAR format file
    const entries = Object.values(requests)
      .filter(req => req.response)
      .map(req => ({
        request: {
          url: req.url,
          method: req.method,
          headers: Object.entries(req.headers).map(([name, value]) => ({ name, value })),
          postData: req.postData ? { text: req.postData } : undefined
        },
        response: {
          status: req.response.status,
          statusText: req.response.status.toString(),
          headers: Object.entries(req.response.headers).map(([name, value]) => ({ name, value })),
          content: {
            text: req.response.body
          }
        }
      }));
    
    fs.writeFileSync(
      path.join(__dirname, 'network_log.har'),
      JSON.stringify({
        log: {
          version: '1.2',
          creator: {
            name: 'Puppeteer',
            version: '1.0'
          },
          entries
        }
      }, null, 2)
    );
    
    console.log('Test completed successfully. Data captured to files.');
  } catch (error) {
    console.error('Error during testing:', error);
  } finally {
    await browser.close();
    console.log('Browser closed.');
  }
})();
