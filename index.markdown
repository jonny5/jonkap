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
  <div style="position: absolute; width: 150px; right: 20%; top: 10%">
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
  </div>
  <div id="scene-container" style="position: relative">
    <div class="video-container" style="display: none;">
      <video muted autoplay loop playsinline id="myVideo">
        <source src="assets/videos/lightning.mp4" type="video/mp4">
      </video>
    </div>
    <div class="robot" style="margin-top: 150px">
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

<style>
  body {
    transition: background-color 1s ease;
  }
  body.fade-to-black {
    background-color: black;
  }
  body.fade-to-black * {
    color: white;
  }
  .cloud {
    cursor: pointer;
  }
  .fade-to-black .robot {
    position: relative;
    z-index: 10;
  }
  .video-container {
    position: absolute;
    top: -80px;
    left: -240px;
    width: 100%;
    height: 100%;
    z-index: 5;
    display: none;
  }

  @keyframes lightningStrike {
    0% {
      filter: blur(0px) brightness(100%);
    }
    10% {
      filter: blur(2px) brightness(200%);
    }
    60% {
      filter: blur(0px) brightness(100%);
    }
    80% {
      filter: blur(2px) brightness(200%);
    }
    100% {
      filter: blur(0px) brightness(100%);
    }
  }

  .spin-robot {
    animation: lightningStrike 4s linear 1;
    transform-style: preserve-3d;
  }

  .robot {
    transition: transform 0.5s ease-in-out;
    transform-style: preserve-3d;
  }

  .robot img {
    backface-visibility: visible;
  }

  #cloud-container {
    position: relative;
    width: 100%;
    height: 100%;
  }

  #cloud-container img {
    position: absolute;
    top: 0;
    left: 0;
  }

  #cloud-container:hover #cloud-image {
    display: none;
  }

  #cloudhappy-image {
    display: none;
  }

  #cloud-container:hover #cloudhappy-image {
    display: block;
  }

  .nes {
    transition: opacity 0.5s ease;
  }
  .hidden {
    display: none;
  }

  #cloudshock-image {
    filter: brightness(0.7) /* Darken the image */ contrast(120%) /* Increase contrast */ grayscale(100%)
      /* Convert to grayscale */ drop-shadow(0 0 10px rgba(255, 255, 255, 0.3)); /* Add a subtle glow */

    /* Optional: Add animation for a lightning effect */
    animation: lightning 2s linear;
  }

  @keyframes lightning {
    0%,
    20%,
    40%,
    60%,
    80% {
      filter: brightness(0.7) contrast(120%) grayscale(100%) drop-shadow(0 0 10px rgba(255, 255, 255, 0.3));
    }
    10%,
    30%,
    50%,
    70%,
    90% {
      filter: brightness(1.2) contrast(120%) grayscale(100%) drop-shadow(0 0 10px rgba(255, 255, 255, 0.7));
    }
    100% {
      filter: brightness(0.7) contrast(120%) grayscale(100%) drop-shadow(0 0 10px rgba(255, 255, 255, 0.3));
    }
  }

  .video-container {
    width: 100%;
    max-width: 640px; /* This matches the width you set in the video tag */
    margin: 0 auto; /* This centers the container if it's narrower than its parent */
  }

  .video-container video {
    width: 100%;
    height: auto;
    max-width: 100%;
    display: block; /* This removes any unwanted space below the video */
  }
</style>
