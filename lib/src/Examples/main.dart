/*
* Copyright (2006 as c)-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions: dynamic 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/
part of acanvas_physics;

class Main extends MovieClip {
  //===============
  // Member data
  //===============
  static FpsCounter m_fpsCounter;
  Stopwatch watch = new Stopwatch()..start();
  int m_currId = 0;
  static Test m_currTest;
  static Sprite m_sprite;
  static TextField m_aboutText;
  // input
  Input m_input;

  Main() {
    m_fpsCounter = new FpsCounter(watch);

    m_fpsCounter.x = 7;
    m_fpsCounter.y = 5;
    addChildAt(m_fpsCounter, 0);

    m_sprite = new Sprite();
    m_sprite.addEventListener(Event.ADDED_TO_STAGE, _onAddedToStage);
    addChild(m_sprite);
  }

  void _onAddedToStage(Event event) {
    // input
    m_input = new Input(m_sprite);

    //Instructions Text
    TextField instructions_text = new TextField();

    TextFormat instructions_text_format = new TextFormat("Arial", 16, 0xffffffff, bold: false);
    instructions_text_format.align = TextFormatAlign.RIGHT;

    instructions_text.defaultTextFormat = instructions_text_format;
    instructions_text.x = 140;
    instructions_text.y = 4.5;
    instructions_text.width = 495;
    instructions_text.height = 61;
    instructions_text.text =
        "Box2DFlashAS3 2.0.1\n'Left'/'Right' arrows to go to previous/next example. \n'R' to reset.";
    addChild(instructions_text);

    // textfield pointer
    m_aboutText = new TextField();
    TextFormat m_aboutTextFormat = new TextFormat("Arial", 16, 0xFF00CCFF, bold: true);
    m_aboutTextFormat.align = TextFormatAlign.RIGHT;
    m_aboutText.defaultTextFormat = m_aboutTextFormat;
    m_aboutText.x = 334;
    m_aboutText.y = 71;
    m_aboutText.width = 300;
    m_aboutText.height = 60;
    addChild(m_aboutText);

    // Thanks to everyone who contacted me about this fix
    instructions_text.mouseEnabled = false;
    m_aboutText.mouseEnabled = false;

    addEventListener(Event.ENTER_FRAME, update, useCapture: false, priority: 0);
  }

  void update(Event e) {
    // clear for rendering
    m_sprite.graphics.clear();

    // toggle between tests
    if (Input.isKeyPressed(39)) {
      // Right Arrow
      m_currId++;
      m_currTest = null;
    } else if (Input.isKeyPressed(37)) {
      // Left Arrow
      m_currId--;
      m_currTest = null;
    } // Reset
    else if (Input.isKeyPressed(82)) {
      // R
      m_currTest = null;
    }

    // if null, set new test
    if (m_currTest == null) {
      m_currId = (m_currId + 11) % 11;
      switch (m_currId) {
        case 0:
          m_currTest = new TestStack(watch);
          break;
        case 1:
          m_currTest = new TestCompound(watch);
          break;
        case 2:
          m_currTest = new TestCrankGearsPulley(watch);
          break;
        case 3:
          m_currTest = new TestBridge(watch);
          break;
        case 4:
          m_currTest = new TestRagdoll(watch);
          break;
        case 5:
          m_currTest = new TestCCD(watch);
          break;
        case 6:
          m_currTest = new TestTheoJansen(watch);
          break;
        case 7:
          m_currTest = new TestBuoyancy(watch);
          break;
        case 8:
          m_currTest = new TestOneSidedPlatform(watch);
          break;
        case 9:
          m_currTest = new TestBreakable(watch);
          break;
        case 10:
          m_currTest = new TestRaycast(watch);
          break;
        default:
          m_currTest = new TestRagdoll(watch);
      }
    }

    // update current test
    m_currTest.Update();

    // Update input (last)
    Input.update();

    // update counter and limit framerate
    m_fpsCounter.update();
    FRateLimiter.limitFrame(30);
  }
}
