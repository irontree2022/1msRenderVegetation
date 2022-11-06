using UnityEngine;

namespace Boxophobic.StyledGUI
{
    public class StyledMask : PropertyAttribute
    {
        public string options = "";

        public int top = 0;
        public int down = 0;

        public StyledMask(string options)
        {
            this.options = options;

            this.top = 0;
            this.down = 0;
        }

        public StyledMask(string options, int top, int down)
        {
            this.options = options;

            this.top = top;
            this.down = down;
        }
    }
}

