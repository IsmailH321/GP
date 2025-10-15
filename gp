## Download modules
import subprocess
import sys

def install_pygame():
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pygame"])

if __name__ == "__main__":
    install_pygame()
    print("pygame installation completed!")


## Learn Basic Game Designing Techniques with pygame.
import pygame
import sys
pygame.init()
screen = pygame.display.set_mode((800, 600))
pygame.display.set_caption("Squid Games")
dark_red = (139, 0, 0)
black = (0, 0, 0)
circle_radius = 50
circle_position = (150, 300)
triangle_points = [(250, 250), (350, 250), (300, 150)]
square_size = 100
square_position = (450, 250)
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
    screen.fill(black)
    pygame.draw.circle(screen, dark_red, circle_position, circle_radius)
    pygame.draw.polygon(screen, dark_red, triangle_points)
    pygame.draw.rect(screen, dark_red, pygame.Rect(square_position, (square_size, square_size)))
    pygame.display.update()



## Snake game
import pygame
import sys
import random

pygame.init()

width, height = 600, 400
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Snake Game")

black = (0, 0, 0)
green = (0, 255, 0)
red = (255, 0, 0)
white = (255, 255, 255)

snake_block = 20
snake_speed = 10

clock = pygame.time.Clock()

def display_score(score):
    font_style = pygame.font.SysFont("bahnschrift", 25)
    value = font_style.render(f"Score: {score}", True, white)
    screen.blit(value, [0, 0])

def message(msg, color):
    font_style = pygame.font.SysFont("bahnschrift", 25)
    mesg = font_style.render(msg, True, color)
    screen.blit(mesg, [width / 6, height / 3])

def gameLoop():
    game_over = False
    x1 = width / 2
    y1 = height / 2
    x1_change = 0
    y1_change = 0

    snake_length = 1
    snake_list = []

    foodx = random.randrange(0, width - snake_block, snake_block)
    foody = random.randrange(0, height - snake_block, snake_block)

    while not game_over:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.KEYDOWN:
                if event.key == pygame.K_LEFT:
                    x1_change = -snake_block
                    y1_change = 0
                elif event.key == pygame.K_RIGHT:
                    x1_change = snake_block
                    y1_change = 0
                elif event.key == pygame.K_UP:
                    y1_change = -snake_block
                    x1_change = 0
                elif event.key == pygame.K_DOWN:
                    y1_change = snake_block
                    x1_change = 0

        if x1 >= width or x1 < 0 or y1 >= height or y1 < 0:
            game_over = True

        x1 += x1_change
        y1 += y1_change
        screen.fill(black)
        pygame.draw.rect(screen, red, [foodx, foody, snake_block, snake_block])

        snake_head = [x1, y1]
        snake_list.append(snake_head)

        if len(snake_list) > snake_length:
            del snake_list[0]

        if snake_head in snake_list[:-1]:
            game_over = True

        for segment in snake_list:
            pygame.draw.rect(screen, green, [segment[0], segment[1], snake_block, snake_block])

        display_score(snake_length - 1)
        pygame.display.update()

        if x1 == foodx and y1 == foody:
            foodx = random.randrange(0, width - snake_block, snake_block)
            foody = random.randrange(0, height - snake_block, snake_block)
            snake_length += 1

        clock.tick(snake_speed)

    message("Game Over! Press Close to Exit.", red)
    pygame.display.update()

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()

gameLoop()



## 2D Target Shooting game
import pygame
import random

pygame.init()

width, height = 800, 600
screen = pygame.display.set_mode((width, height))
pygame.display.set_caption("Shooting Game")

white = (255, 255, 255)
red = (255, 0, 0)
blue = (0, 0, 255)

character_size = 50
character_speed = 5
character = pygame.Rect(width // 2 - character_size // 2, height - character_size, character_size, character_size)

bullet_size = 10
bullets = []

enemy_radius = 20
enemies = []

score = 0
clock = pygame.time.Clock()

running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                bullet = pygame.Rect(character.centerx - bullet_size // 2, character.top, bullet_size, bullet_size)
                bullets.append(bullet)

    for bullet in bullets[:]:
        bullet.y -= 10
        if bullet.top < 0:
            bullets.remove(bullet)

    if random.randint(1, 100) <= 2:
        enemy_x = random.randint(enemy_radius, width - enemy_radius)
        enemy = pygame.Rect(enemy_x - enemy_radius, 0, enemy_radius * 2, enemy_radius * 2)
        enemies.append(enemy)

    for enemy in enemies[:]:
        enemy.y += 5
        if enemy.top > height:
            enemies.remove(enemy)

    keys = pygame.key.get_pressed()
    if keys[pygame.K_LEFT]:
        character.x -= character_speed
    if keys[pygame.K_RIGHT]:
        character.x += character_speed

    for bullet in bullets[:]:
        for enemy in enemies[:]:
            if bullet.colliderect(enemy):
                score += 1
                if bullet in bullets:
                    bullets.remove(bullet)
                if enemy in enemies:
                    enemies.remove(enemy)
                break

    for enemy in enemies:
        if character.colliderect(enemy):
            running = False

    screen.fill(white)

    for bullet in bullets:
        pygame.draw.polygon(screen, blue, [(bullet.left, bullet.bottom), (bullet.centerx, bullet.top), (bullet.right, bullet.bottom)])

    pygame.draw.rect(screen, red, character)

    for enemy in enemies:
        pygame.draw.circle(screen, red, enemy.center, enemy_radius)

    font = pygame.font.Font(None, 36)
    score_text = font.render(f"Score: {score}", True, red)
    screen.blit(score_text, (10, 10))

    pygame.display.flip()
    clock.tick(60)

font = pygame.font.Font(None, 72)
game_over_text = font.render("Game Over", True, red)
screen.blit(game_over_text, (width // 2 - game_over_text.get_width() // 2, height // 2 - game_over_text.get_height() // 2))
pygame.display.flip()
pygame.time.wait(3000)
pygame.quit()



## 2D infinite scrolling Background
Step 1: Set Up Your Scene
Create a new 2D project in Unity.
Import your background image(s) into the project.
Create a GameObject (e.g., an empty object named BackgroundHolder).
Add your background sprite(s) as child GameObjects of BackgroundHolder.
Step 2: Prepare the Background Sprites
Select each background sprite in the scene.
Make sure their Pivot is set correctly (usually center or left aligned).
Note the width of the background sprite in world units
Step 3: Create a Scrolling Script
using UnityEngine;
public class InfiniteScroll : MonoBehaviour
{
    public float scrollSpeed = 2f;
    private float spriteWidth;
    private Vector3 startPosition;
    void Start()
    {
        startPosition = transform.position;
        spriteWidth = transform.GetChild(0).GetComponent<SpriteRenderer>().bounds.size.x;
    }
    void Update()
    {
        float newPosition = Mathf.Repeat(Time.time * scrollSpeed, spriteWidth);
        transform.position = startPosition + Vector3.left * newPosition;
    }
}
Step 4: Duplicate Background Sprites
To ensure the infinite effect, you need at least two background sprites placed side by side:
For example, if one sprite is 10 units wide, place one at (0,0) and the second at (10,0).
The script scrolls the whole BackgroundHolder, and when the offset reaches the width, it loops back.
Step 5: Test and Adjust
Press Play and see the background scroll.
Adjust the scrollSpeed to your liking.
Add more background sprites if needed for smoother looping.

#code
#select 2d game and import an image in it
#select img and from inspector select "Texture Type" as "Texture" and "Wrap Mode" as "repeat" and click apply
#go to GameObject from upper panel and 3d object>Quad and scale it from inspector as "X=20" and "Y=10"
#go to GameObject> Light> Directional Light
#select the img and drag & drop in the quad and adjust light intensity
#select img and in inspector click "add component"> new script> name it> create
#below "public class scroll.." write "public float speed = 0.5f;"
#below last line "void update()" write "Vector2 offset = new Vector2 (Time.time * speed, 0);"
#below that write "renderer.material.mainTexturreOffset = offset;"
#click run from above



## Camera shake effect
STEP 1 : Start Unity
STEP 2 : Create new project 2D. Add project name
STEP 3 : Add folders such as Sprites, Scenes, Scripts, etc
STEP 4 : Add Assets by right-click > Import Asset
STEP 5 : Import the Following assets : Background and UFO
STEP 6 : Drag the assets to the Hierarchy > Click and hold asset and drag under MainCamera SImilarly, Drag and add the UFO under the background
STEP 7 : Adjust the MainCamera by changing the size
STEP 8 : Select the UFO from Hierarchy. To make the UFO layer appear above the Background, Add a sorting layer,
and select the layer. Update the following settings for UFO. Add a circle collider and adjust the radius. Adjust gravity Scale
Rigidbodies are components that allow a GameObject to react to real-time physics. This includes reactions to forces and gravity, mass, drag and
momentum. You can attach a Rigidbody to your GameObject by simply clicking on Add Component and typing in Rigidbody2D in the search field.
STEP 9 : Select the Background from Hierarchy. Add a box collider from Add component > Box Collider 2D. Do this step 4 times for each border of
the box collider. Also, set the Shake Frequency which set the intensity of the Shake Effect
STEP 10 : To implement the camera shake effect, add a new script as follows:
public Transform cameraTransform = default;
private Vector3 _orignalPosOfCam = default;
public float shakeFrequency = default;
void Start()
{
    _orignalPosOfCam = cameraTransform.position;
}
void Update()
{
    if (Input.GetKey(KeyCode.S))
    {
        CameraShake();
    }
    else if (Input.GetKeyUp(KeyCode.S))
    {
        StopShake();
    }
}
private void CameraShake()
{
    cameraTransform.position = _orignalPosOfCam + Random.insideUnitSphere * shakeFrequency;
}
private void StopShake()
{
    cameraTransform.position = _orignalPosOfCam;
}
The final output will result in the Camera Shake Effect on pressing the key ‘S’



## Snowfall particle effect
1. Create a New Particle System:
• In the Unity Editor, select the GameObject where you want to add the
snowfall effect.
• Go to the menu bar and select GameObject > Effects > Particle System.
This will create a new Particle System component attached to the selected
GameObject.
2. Configure the Particle System:
• In the Inspector window, you'll see the Particle System component's settings.
Adjust these settings to create a snowfall effect:
• Duration: Set this to a value that suits the length of your snowfall scene. For
an ongoing snowfall, you can set it to a high value or loop the system.
• Start Lifetime: This determines how long each snowflake particle will stay on
screen. Set it to a value that makes the snowflakes fall for an appropriate
amount of time (e.g., 5 seconds).
• Start Speed: Adjust the initial speed of the snowflakes. Typically, a small
value like 1-5 units per second will work.
• Start Size: Set the size of the snowflakes. They should be small, like 0.05 to 0.2.
• Start Color: Choose a light blue or white color to resemble snow.
• Emission: Configure the rate at which particles are emitted. Set the rate to
create a dense snowfall. For example, you might try starting with 100 particles
per second.
• Shape: Choose "Cone" as the shape and adjust the angle and radius to control
the area where snowflakes will spawn.
• Gravity Modifier: Apply a downward force (negative value) to simulate
gravity. Use a small negative value, like -0.1, to make snowflakes fall gently.
3. Texture for Snowflakes:
• You can use a custom texture for your snowflakes. In the Particle System
settings, under the Renderer module, set the Material to a particle material that
uses a snowflake texture. Ensure the snowflake texture is set to have a
transparent background.
4. Tweak Additional Settings:
• You can further enhance the effect by adjusting settings like Color Over
Lifetime, Size Over Lifetime, and Rotation Over Lifetime to add variation to
the snowflakes.
5. Play the Scene:
• Press the Play button in Unity to see your snowfall effect in action.

#code:
#Go to hirarchy window>click "+"> Effects> Particle System> Name it
#go to inspector and select shape> select shape "Box"> scale X=10 & Z=10
#in inspector go to "start speed" and type 0
#in inspector below enable "velocity over lifetime> scale Y=-5"
#in inspector> Emission> Rate over time = 100
#in inspector> start size> use dropdown box add 2 slote and scale from 0.05 to 0.2
#inspector> enable size ove lifetime> particle system curve> choose high to low



## Setup DirectX 11, Window Framework and Initialize Direct3D Device, Loading 
   models into DirectX 11 and rendering
Step 1: Create new project, and select “Windows Forms Application”, select .NET Framework as 2.0 in
Visuals C#.
Step 2: Right Click on properties Click on open click on build Select Platform Target and Select x86.
Step 3: Click on View Code of Form 1.
Step 4: Go to Solution Explorer, right click on project name, and select Add Reference. Click on Browse
and select the given .dll files which are “Microsoft.DirectX”, “Microsoft.DirectX.Direct3D”, and
“Microsoft.DirectX.DirectX3DX”.
Step 5: Go to Properties Section of Form, select Paint in the Event List and enter as Form1_Paint.
Step 6: Edit the Form’s C# code file.
Step 7: When you run this code you get exception for LoaderLock. To solve this exception, go in
exception thrown window, open exception setting, select and expand managed debugging assistant,
and uncheck the loader lock option, then run your program.

##C:windows:.net:DirectX Managed Code
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
namespace WindowsFormsApplication5
{
public partial class Form1 : Form

{
Microsoft.DirectX.Direct3D.Device device;
public Form1()
{
InitializeComponent();
InitDevice();
}
private void InitDevice()
{
PresentParameters pp = new PresentParameters(); //CREATE OBJECT
pp.Windowed = true;
pp.SwapEffect = SwapEffect.Discard;
device = new Device(0, DeviceType.Hardware, this, CreateFlags.HardwareVertexProcessing, pp);
}
private void Render()
{
device.Clear(ClearFlags.Target, Color.Blue,0,1);
device.Present();
}
private void Form1_Paint_1(object sender, PaintEventArgs e)
{
Render();
}
}
}

##Loading models (image and fonts) into DirectX 11 and rendering.
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
namespace WindowsFormsApplication10
{
public partial class Form1 : Form
{
Microsoft.DirectX.Direct3D.Device device;
Microsoft.DirectX.Direct3D.Texture texture;
Microsoft.DirectX.Direct3D.Font font;
public Form1()
{
InitializeComponent();
InitDevice();
InitFont();
LoadTexture();
}
private void InitFont()
{
System.Drawing.Font f = new System.Drawing.Font("Arial", 16f, FontStyle.Regular); font =
new Microsoft.DirectX.Direct3D.Font(device, f);
}
private void LoadTexture()
{
texture = TextureLoader.FromFile(device, "C:\\Users\\Public\\Pictures\\Sample Pictures\\Desert.jpg", 400, 400,
1, 0, Format.A8B8G8R8, Pool.Managed, Filter.Point, Filter.Point, Color.Transparent.ToArgb()); }
private void InitDevice()
{
PresentParameters pp = new PresentParameters();
pp.Windowed = true;
pp.SwapEffect = SwapEffect.Discard;
device = new Device(0, DeviceType.Hardware, this, CreateFlags.HardwareVertexProcessing, pp);
}
private void Render()
{
device.Clear(ClearFlags.Target, Color.CornflowerBlue, 0, 1);
device.BeginScene();
using (Sprite s = new Sprite(device))
{
s.Begin(SpriteFlags.AlphaBlend);
s.Draw2D(texture, new Rectangle(0, 0, 0, 0), new Rectangle(0, 0, device.Viewport.Width,
device.Viewport.Height), new Point(0, 0), 0f, new Point(0, 0), Color.White);
font.DrawText(s, "Desert", new Point(0, 0), Color.White);
s.End();
}
device.EndScene();
device.Present()
}
private void Form1_Paint(object sender, PaintEventArgs e)
{
Render();
}
private void Form1_Load(object sender, EventArgs e)
{
}
}

