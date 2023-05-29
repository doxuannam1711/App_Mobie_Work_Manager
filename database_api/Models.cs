using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace WebApiDemo.Models
{
    public class BoardModel
    {
            public int BoardId { get; set; }
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
        public string CardName { get; set; }
        public int Checklist { get; set; }
        public string Label { get; set; }
        public int Comment { get; set; }
        public DateTime DueDate { get; set; }
        public string LabelColor { get; set; }
        public int IntCheckList { get; set; }
        public int CreatorID { get; set; } 
        public int ListID { get; set; }
        public DateTime CreatedDate { get; set; } 
    }
    public class CheckListItemModel
    {
        public int CardID { get; set; }
        public string Title { get; set; }
        public bool Completed { get; set; }
    }

    public class ListModel
    {
        public int ListID { get; set; }
        public string ListName { get; set; }   
        public int BoardID { get; set; }
    }

    public class CommentModel
    {
        public int CommentID { get; set; }
        public int UserID { get; set; }
        public string CardID { get; set; }
        public string Detail { get; set; }

    }


    public class AttachmentModel
    {
        public int AttachmentID { get; set; }
        public int CardID { get; set; }
        public string AttachmentPath { get; set; }
        public string AttachmentName { get; set; }

    }

    public class MemberModel
    {
        public string fullname { get; set; }
        public string Email { get; set; }
        public string AvatarUrl { get; set; }
        public int assignedTo { get; set; }

    }
}