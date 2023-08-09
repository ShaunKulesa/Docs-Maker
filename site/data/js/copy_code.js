// copy-to-clipboard.js

document.addEventListener("DOMContentLoaded", function(){
  // Find all copy buttons and add a click event listener to each
  document.querySelectorAll('.copy-button').forEach(function(button) {
    button.addEventListener('click', function(e) {
      // Get the <pre><code> block related to this button
      var code = button.nextElementSibling.querySelector('code').innerText;

      // Create a temporary textarea and copy the code into it
      var textarea = document.createElement('textarea');
      textarea.value = code;
      document.body.appendChild(textarea);

      // Select the text and copy it to the clipboard
      textarea.select();
      document.execCommand('copy');

      // Remove the temporary textarea
      document.body.removeChild(textarea);
    });
  });
});

