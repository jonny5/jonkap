---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
custom_css: home
test_variable: This is a test
---
<div class="home">
  {%- if page.title -%}
    <h1 class="page-heading">{{ page.title }}</h1>
  {%- endif -%}

  <div style="margin-top: 100px">
    <img class="armless" src="{{ site.baseurl }}/assets/images/armless.png">
    <img class="arm-image rotating-element" src="{{ site.baseurl }}/assets/images/arm.png">
    <div class="nes nes-dialog-wrapper" style="">
      <div class="nes-balloon from-left dialog-box" id="game-dialog">
        <p id="dialog-text"></p>
        <div id="continue-indicator">▼</div>
      </div>
    </div>
  </div>
</div>

<script>
  let dialogueIndex = 0;
  let isTyping = false;
  const dialogueSegments = ['Hello there!', 'Welcome to my site!', 'Stay awhile and click around!'];

  function typeWriter(text, speed = 24) {
    isTyping = true;
    let i = 0;
    const dialogText = document.getElementById('dialog-text');
    const continueIndicator = document.getElementById('continue-indicator');
    dialogText.textContent = ''; // Clear existing text
    continueIndicator.style.display = 'none';

    function type() {
      if (i < text.length) {
        dialogText.textContent += text.charAt(i);
        i++;
        setTimeout(type, speed);
      } else {
        isTyping = false;
        if (dialogueIndex < dialogueSegments.length - 1) {
          continueIndicator.style.display = 'block';
        }
      }
    }

    type();
  }

  function advanceDialogue() {
    if (!isTyping) {
      dialogueIndex++;
      if (dialogueIndex < dialogueSegments.length) {
        typeWriter(dialogueSegments[dialogueIndex]);
      } else {
        document.getElementById('continue-indicator').style.display = 'none';
      }
    }
  }

  document.addEventListener('DOMContentLoaded', (event) => {
    const dialogBox = document.getElementById('game-dialog');
    dialogBox.addEventListener('click', advanceDialogue);
    typeWriter(dialogueSegments[0]);
  });
</script>
