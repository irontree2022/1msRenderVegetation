// Cristian Pop - https://boxophobic.com/

using UnityEngine;

namespace Boxophobic.StyledGUI
{
    public class StyledText : PropertyAttribute
    {
        public string text = "";
        public TextAnchor alignment = TextAnchor.MiddleCenter;
        public bool disabled = false;
        public float top = 0;
        public float down = 0;

        public StyledText()
        {
        }

        public StyledText(TextAnchor alignment, bool disabled)
        {
            this.alignment = alignment;
            this.disabled = disabled;
        }

        public StyledText(TextAnchor alignment, bool disabled, float top, float down)
        {
            this.alignment = alignment;
            this.disabled = disabled;
            this.top = top;
            this.down = down;
        }
    }
}

