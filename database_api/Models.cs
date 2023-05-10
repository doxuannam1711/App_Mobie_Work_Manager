using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace WebApiDemo.Models
{
   public class BoardModel
   {
      public string BoardName { get; set; }
      public DateTime CreatedDate { get; set; }
      public int UserID { get; set; }
      public string Labels { get; set; }
      public string LabelsColor { get; set; }
   }
   public class UserModel
   {
      public int UserID { get; set; }
      public string Username { get; set; }
      public string Fullname { get; set; }
      public string Password { get; set; }
      public string Email { get; set; }
      public string AvatarUrl { get; set; }
      public int RoleID { get; set; }
      public DateTime CreatedDate { get; set; }
      public DateTime LastLoginTime { get; set; }
   }
   public class CardModel
   {
      public int CardID { get; set; }
      public int ListID { get; set; }
      public int CreatorID { get; set; }
      public string CardName { get; set; }
      public string Label { get; set; }
      public int Comment { get; set; }
      public DateTime CreatedDate { get; set; }

      public DateTime DueDate { get; set; }
      public string LabelColor { get; set; }

   }


    public class ListModel
    {
        public int ListID { get; set; }
        public string ListName { get; set; }   
    }
   public class CheckListItemModel
   {
      public int ChecklistitemID { get; set; }
      public int ChecklistID { get; set; }
      public string Title { get; set; }

   }
   public class CommentModel
   {
      public int CommentID { get; set; }
      public int UserID { get; set; }
      public string CardID { get; set; }
      public string Detail { get; set; }

   }
}