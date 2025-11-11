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
  <div id="cloud-container">
    <img src="{{ site.baseurl }}/assets/images/cloud.png" class="cloud" id="cloud-image">
    <img
      src="{{ site.baseurl }}/assets/images/cloudhappy.png"
      class="cloud cloud-hover hidden"
      id="cloudhappy-image"
    >
    <img
      src="{{ site.baseurl }}/assets/images/cloudshock.png"
      class="cloud hidden"
      id="cloudshock-image"
    >
  </div>
  <div id="scene-container">
    <div class="video-container" style="display: none;">
      <video muted autoplay loop playsinline id="myVideo">
        <source src="assets/videos/lightning.mp4" type="video/mp4">
      </video>
    </div>

    <div class="content-wrapper">
      <div class="robot">
        <img class="armless" src="{{ site.baseurl }}/assets/images/armless.png">
        <img class="arm-image rotating-element" src="{{ site.baseurl }}/assets/images/arm.png">
        <div class="nes nes-dialog-wrapper">
          <div class="nes-balloon from-left dialog-box" id="game-dialog">
            <p id="dialog-text"></p>
            <div id="continue-indicator">▼</div>
          </div>
        </div>
      </div>

      <p id="home-description">
        The header has all the relevant links, here is <a href="/welcome">the welcome post</a> for
        <a href="/blog">my blog</a>.
      </p>
    </div>
  </div>
</div>

<script>
  let alreadyAlive = false;
  let dialogueIndex = 0;
  let isTyping = false;
  function getGreeting() {
    const hour = new Date().getHours();

    if (hour >= 5 && hour < 12) {
      return 'Good morning!';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon!';
    } else {
      return 'Good evening!';
    }
  }
  const firstDialogueSegments = [getGreeting(), 'Hello there!', 'Howdy!'];
  const dialogueSegments = [
    firstDialogueSegments[Math.floor(Math.random() * firstDialogueSegments.length)],
    'Welcome to my site!',
    'Stay awhile and click around!',
  ];

  function typeWriter(text, speed = 24) {
    isTyping = true;
    let i = 0;
    const dialogText = document.getElementById('dialog-text');
    const continueIndicator = document.getElementById('continue-indicator');
    dialogText.innerHTML = ''; // Change textContent to innerHTML
    continueIndicator.style.display = 'none';
    function type() {
      if (i < text.length) {
        dialogText.innerHTML += text.charAt(i); // Change textContent to innerHTML
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

  document.addEventListener('DOMContentLoaded', function () {
    var video = document.getElementById('myVideo');
    video.playbackRate = 0.5;

    const cloudImage = document.getElementById('cloud-image');
    const cloudHappyImage = document.getElementById('cloudhappy-image');
    const cloudContainer = document.getElementById('cloud-container');
    const cloudShockImage = document.getElementById('cloudshock-image');
    const sceneContainer = document.getElementById('scene-container');
    const videoContainer = document.querySelector('.video-container');
    const nesElement = document.querySelector('.nes');
    const armImage = document.querySelector('.arm-image');
    const robot = document.querySelector('.armless');
    const dialogText = document.getElementById('dialog-text');
    const textContainer = document.getElementById('home-description');

    cloudContainer.addEventListener('click', function () {
      if (alreadyAlive) {
        if (!isTyping) {
          typeWriter("I'm already alive!");
        }
        return;
      }
      cloudImage.classList.add('hidden');
      cloudHappyImage.classList.add('hidden');
      cloudShockImage.classList.remove('hidden');

      setTimeout(() => {
        cloudShockImage.classList.add('hidden');
        cloudContainer.classList.add('hidden');
        document.body.classList.add('fade-to-black');
        textContainer.classList.add('hidden');
        nesElement.style.display = 'none';
        armImage.classList.remove('rotating-element');

        setTimeout(() => {
          videoContainer.style.display = 'block';
          video.play();

          robot.classList.add('spin-robot');
          armImage.classList.add('spin-robot');

          setTimeout(() => {
            videoContainer.style.display = 'none';
            robot.classList.remove('spin-robot');
            armImage.classList.remove('spin-robot');
            document.body.classList.remove('fade-to-black');
            cloudContainer.classList.remove('hidden');
            cloudImage.classList.remove('hidden');
            textContainer.classList.remove('hidden');

            setTimeout(() => {
              nesElement.style.display = 'block';
              armImage.classList.add('rotating-element');
              typeWriter('JONNY 5 IS ALIVE!!!!!');
              alreadyAlive = true;
            }, 500);
          }, 4000);
        }, 1000);
      }, 1000);
    });
  });
</script>

<style></style>
