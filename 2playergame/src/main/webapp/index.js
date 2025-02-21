const canvas = document.querySelector('canvas');
const c = canvas.getContext('2d');

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

c.fillRect(0, 0, canvas.width, canvas.height);

const gravity = 0.7;
let playerJumping = false;
let enemyJumping = false;

const background = new Sprite({
  position: {
    x: 80,
    y: 50
  },
  imageSrc: 'img/background.png',
  scale: 1.7
});

const shop = new Sprite({
  position: {
    x: 1200,
    y: 418
  },
  imageSrc: './img/shop.png',
  scale: 3.5,
  framesMax: 6
});

function getUrlParameter(name) {
  name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
  var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
  var results = regex.exec(location.search);
  return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
}

// Get the values of firstUsername and secondUsername from the URL
const firstUsername = getUrlParameter('firstUsername');
const secondUsername = getUrlParameter('secondUsername');

const player = new Fighter({
  position: {
    x: 0,
    y: 0
  },
  velocity: {
    x: 0,
    y: 0
  },
  offset: {
    x: 0,
    y: 0
  },
  imageSrc: 'img/kenji/Idle.png',
  framesMax: 8,
  scale: 2.5,
  offset: {
    x: 100,
    y: 157
  },
  sprites: {
    idle: {
      imageSrc: 'img/samuraiMack/Idle.png',
      framesMax: 8
    },
    run: {
      imageSrc: 'img/samuraiMack/Run.png',
      framesMax: 8
    },
    jump: {
      imageSrc: 'img/samuraiMack/Jump.png',
      framesMax: 2
    },
    fall: {
      imageSrc: 'img/samuraiMack/Fall.png',
      framesMax: 2
    },
    attack1: {
      imageSrc: 'img/samuraiMack/Attack1.png',
      framesMax: 6
    },
    takeHit: {
      imageSrc: './img/samuraiMack/Take Hit - white silhouette.png',
      framesMax: 4
    },
    death: {
      imageSrc: './img/samuraiMack/Death.png',
      framesMax: 6
    }
  },
  attackBox: {
    offset: {
      x: 100,
      y: 50
    },
    width: 160,
    height: 50
  }
});

const enemy = new Fighter({
  position: {
    x: 1600,
    y: 100
  },
  velocity: {
    x: 0,
    y: 0
  },
  color: 'blue',
  offset: {
    x: -50,
    y: 0
  },
  imageSrc: './img/kenji/Idle.png',
  framesMax: 4,
  scale: 2.5,
  frameElapse: 0,
  offset: {
    x: 100,
    y: 167
  },
  sprites: {
    idle: {
      imageSrc: './img/kenji/Idle.png',
      framesMax: 4
    },
    run: {
      imageSrc: './img/kenji/Run.png',
      framesMax: 8
    },
    jump: {
      imageSrc: './img/kenji/Jump.png',
      framesMax: 2
    },
    fall: {
      imageSrc: './img/kenji/Fall.png',
      framesMax: 2
    },
    attack1: {
      imageSrc: './img/kenji/Attack1.png',
      framesMax: 4
    },
    takeHit: {
      imageSrc: './img/kenji/Take hit.png',
      framesMax: 3
    },
    death: {
      imageSrc: './img/kenji/Death.png',
      framesMax: 7
    }
  },
  attackBox: {
    offset: {
      x: -170,
      y: 50
    },
    width: 170,
    height: 50
  }
});

console.log(player);

const keys = {
  a: {
    pressed: false
  },
  d: {
    pressed: false
  },
  ArrowRight: {
    pressed: false
  },
  ArrowLeft: {
    pressed: false
  }
};

decreaseTimer();

function animate() {
  window.requestAnimationFrame(animate);

  c.fillStyle = 'black';
  c.fillRect(0, 0, canvas.width, canvas.height);

  background.update();
  shop.update();
  c.fillStyle = 'rgba(0, 0, 0, 0.15)';
  c.fillRect(0, 0, canvas.width, canvas.height);
  player.update();
  enemy.update();

  c.fillStyle = 'white';
  c.font = 'bold 16px Arial';
  c.fillText(firstUsername, player.position.x+140, player.position.y - 0);
  c.fillText(secondUsername, enemy.position.x+105, enemy.position.y - 0);

  player.velocity.x = 0;
  enemy.velocity.x = 0;

  // Player movement
  if (keys.a.pressed && player.lastKey === 'a') {
    player.velocity.x = -5;
    player.switchSprite('run');
  } else if (keys.d.pressed && player.lastKey === 'd') {
    player.velocity.x = 5;
    player.switchSprite('run');
  } else {
    player.switchSprite('idle');
  }

  // Jumping
  if (player.velocity.y < 0) {
    player.switchSprite('jump');
  } else if (player.velocity.y > 0) {
    player.switchSprite('fall');
  }

  // Enemy movement
  if (keys.ArrowLeft.pressed && enemy.lastKey === 'ArrowLeft') {
    enemy.velocity.x = -5;
    enemy.switchSprite('run');
  } else if (keys.ArrowRight.pressed && enemy.lastKey === 'ArrowRight') {
    enemy.velocity.x = 5;
    enemy.switchSprite('run');
  } else {
    enemy.switchSprite('idle');
  }

  // Jumping
  if (enemy.velocity.y < 0) {
    enemy.switchSprite('jump');
  } else if (enemy.velocity.y > 0) {
    enemy.switchSprite('fall');
  }

  // Detect collision & enemy gets hit
  if (rectangularCollision({ rectangle1: player, rectangle2: enemy }) && player.isAttacking && player.framesCurrent === 4) {
    enemy.takeHit();
    player.isAttacking = false;

    gsap.to('#enemyHealth', {
      width: enemy.health + '%'
    });
  }

  // If player misses
  if (player.isAttacking && player.framesCurrent === 4) {
    player.isAttacking = false;
  }

  // Player gets hit
  if (rectangularCollision({ rectangle1: enemy, rectangle2: player }) && enemy.isAttacking && enemy.framesCurrent === 2) {
    player.takeHit();
    enemy.isAttacking = false;

    gsap.to('#playerHealth', {
      width: player.health + '%'
    });
  }

  // If enemy misses
  if (enemy.isAttacking && enemy.framesCurrent === 2) {
    enemy.isAttacking = false;
  }

  // End game based on health
  if (enemy.health <= 0 || player.health <= 0) {
    determineWinner({ player, enemy, timerId });
  }
}

animate();

window.addEventListener('keydown', (event) => {
  if (!player.dead) {
    switch (event.key) {
      case 'd':
        keys.d.pressed = true;
        player.lastKey = 'd';
        break;
      case 'a':
        keys.a.pressed = true;
        player.lastKey = 'a';
        break;
      case 'w':
        if (!playerJumping && player.velocity.y === 0) {
          player.velocity.y = -20;
          playerJumping = true;
        }
        break;
      case ' ':
        player.attack();
        break;
    }
  }

  if (!enemy.dead) {
    switch (event.key) {
      case 'ArrowRight':
        keys.ArrowRight.pressed = true;
        enemy.lastKey = 'ArrowRight';
        break;
      case 'ArrowLeft':
        keys.ArrowLeft.pressed = true;
        enemy.lastKey = 'ArrowLeft';
        break;
      case 'ArrowUp':
        if (!enemyJumping && enemy.velocity.y === 0) {
          enemy.velocity.y = -20;
          enemyJumping = true;
        }
        break;
      case 'ArrowDown':
        enemy.attack();
        break;
    }
  }
});

window.addEventListener('keyup', (event) => {
  switch (event.key) {
    case 'd':
      keys.d.pressed = false;
      break;
    case 'a':
      keys.a.pressed = false;
      break;
    case 'ArrowRight':
      keys.ArrowRight.pressed = false;
      break;
    case 'ArrowLeft':
      keys.ArrowLeft.pressed = false;
      break;
    case 'w':
      playerJumping = false;
      break;
    case 'ArrowUp':
      enemyJumping = false;
      break;
  }
});
