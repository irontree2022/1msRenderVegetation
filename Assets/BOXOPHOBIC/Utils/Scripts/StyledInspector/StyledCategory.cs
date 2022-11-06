using UnityEngine;

namespace Boxophobic.StyledGUI
{
    public class StyledCategory : PropertyAttribute
    {
        public string category;
        public int top;
        public int down;

        public StyledCategory(string category)
        {
            this.category = category;
            this.top = 10;
            this.down = 10;
        }
        public StyledCategory(string category, int spaceTop, int spaceBottom)
        {
            this.category = category;
            this.top = spaceTop;
            this.down = spaceBottom;
        }
    }
}

