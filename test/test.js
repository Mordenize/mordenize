// script.js

// Function to add two numbers
function add(a, b) {
    return a + b;
  }
  
  // Arrow function example
  const multiply = (a, b) => a * b;
  
  // Event listener example
  document.addEventListener('DOMContentLoaded', () => {
    console.log('Page loaded');
  });
  
  // Exporting functions for use in other modules
  export { add, multiply };
  