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
      <img src="{{ site.baseurl }}/assets/images/cloudhappy.png" class="cloud cloud-hover" id="cloudhappy-image">
      <img
        src="{{ site.baseurl }}/assets/images/cloudshock.png"
        class="cloud"
        id="cloudshock-image"
        style="opacity: 0;"
      >
    </div>
  </div>
  <div id="scene-container" style="position: relative">
    <div class="video-container" style="opacity: 0;">
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
  let dialogueIndex = 0;
  let isTyping = false;
  const firstDialogueSegments = ['Hello there!', 'Howdy!', '*wave*'];
  const dialogueSegments = [
    firstDialogueSegments[Math.floor(Math.random() * firstDialogueSegments.length)],
    'Welcome to my site!',
    'Stay awhile and click around!',
  ];

  function typeWriter(text, speed = 24) {
    let i = 0;
    const dialogText = document.getElementById('dialog-text');
    dialogText.textContent = ''; // Clear existing text
    function type() {
      if (i < text.length) {
        dialogText.textContent += text.charAt(i);
        i++;
        setTimeout(type, speed);
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
    const cloudhappyImage = document.getElementById('cloudhappy-image');
    const cloudContainer = document.getElementById('cloud-container');

    const cloudshockImage = document.getElementById('cloudshock-image');
    const sceneContainer = document.getElementById('scene-container');
    const videoContainer = document.querySelector('.video-container');
    const nesElement = document.querySelector('.nes');
    const armImage = document.querySelector('.arm-image');
    const robot = document.querySelector('.robot');
    const dialogText = document.getElementById('dialog-text');

    cloudContainer.addEventListener('click', function () {
      cloudImage.style.opacity = '0';
      cloudhappyImage.style.opacity = '0';
      cloudshockImage.style.opacity = '1';

      setTimeout(() => {
        cloudshockImage.style.opacity = '0';
        document.body.classList.add('fade-to-black');
        nesElement.style.opacity = '0';
        armImage.classList.remove('rotating-element');

        setTimeout(() => {
          videoContainer.style.opacity = '1';

          // Show video for 5 seconds, then hide it
          setTimeout(() => {
            videoContainer.style.opacity = '0';
            document.body.classList.remove('fade-to-black');
            cloudImage.style.opacity = '1';
            robot.classList.add('move-robot');

            setTimeout(() => {
              robot.classList.remove('move-robot');
              setTimeout(() => {
                nesElement.style.opacity = '1';
                armImage.classList.add('rotating-element');
                typeWriter('JONNY 5 IS ALIVE!!!!!');
              }, 500);
            }, 3000);
          }, 5000); // Show video for 5 seconds
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
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 5;
    opacity: 0;
    transition: opacity 0.5s ease;
  }

  @keyframes moveRobot {
    0% {
      transform: translateX(0);
    }
    25% {
      transform: translateX(100%);
    }
    50% {
      transform: translateX(0);
    }
    75% {
      transform: translateX(-100%);
    }
    100% {
      transform: translateX(0);
    }
  }

  .move-robot {
    animation: moveRobot 6s ease-in-out;
  }

  .robot {
    transition: transform 0.5s ease-in-out;
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

  .cloud-hover {
    opacity: 0;
  }

  #cloud-container:hover .cloud-hover {
    opacity: 1;
  }

  #cloud-container:hover #cloud-image {
    opacity: 0;
  }

  #cloud-container:hover #cloudhappy-image {
    opacity: 1;
  }

  .nes {
    transition: opacity 0.5s ease;
  }
</style>
