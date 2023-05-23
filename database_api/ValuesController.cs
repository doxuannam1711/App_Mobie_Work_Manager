using System;
using System.Web.Http;
using System.Data;
using Newtonsoft.Json;
using System.Security.Claims;
using System.Data.SqlClient;
using WebApiDemo.Models;
using System.Collections.Generic;
using System.IO;
using System.Net.Http;
using System.Net;
using System.Web;
using CsvHelper.Configuration;
using System.Globalization;
using System.Text;
using CsvHelper;
using System.Web.Razor.Tokenizer.Symbols;
using System.Net.Mail;

public class ValuesController : ApiControllerBase
{
    [Route("api/getAccountLogin")]
    public IHttpActionResult GetAccountToLogin()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * from users";
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }



    [HttpPost]
    [Route("api/addUser")]
    public IHttpActionResult AddUser([FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO users (Username, Fullname, Password, Email, AvatarUrl)
                                 VALUES (@Username, @Fullname, @Password, @Email, @AvatarUrl)";

            Command.Parameters.AddWithValue("@Username", user.Username);
            Command.Parameters.AddWithValue("@Fullname", user.Fullname);
            Command.Parameters.AddWithValue("@Password", user.Password);
            Command.Parameters.AddWithValue("@Email", user.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", user.AvatarUrl);

            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpPut]
    [Route("api/updateUser/{userID}")]
    public IHttpActionResult UpdateUser(int userID, [FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE users SET Username = @Username, Fullname=@Fullname, Password=@Password, Email=@Email, AvatarUrl=@AvatarUrl WHERE UserID = @UserID";
            Command.Parameters.AddWithValue("@Username", user.Username);
            Command.Parameters.AddWithValue("@Fullname", user.Fullname);
            Command.Parameters.AddWithValue("@Password", user.Password);
            Command.Parameters.AddWithValue("@Email", user.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", user.AvatarUrl);

            Command.Parameters.AddWithValue("@UserID", user.UserID);

            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    //[HttpDelete]
    //[Route("api/deleteUser/{userId}")]
    //public IHttpActionResult DeleteUser(int userId)
    //{
    //    try
    //    {
    //        Command.ResetAndOpen(CommandType.Text);
    //        Command.CommandText = @"DELETE FROM users WHERE UserID = @UserID";
    //        Command.Parameters.AddWithValue("@UserID", userId);
    //        Command.ExecuteNonQuery();
    //        var response = new ResultModel { };
    //        return Ok(response);
    //    }
    //    catch (Exception ex)
    //    {
    //        return Ok(ex.Message);
    //    }
    //}




    [Route("api/getAccount/{userID}")]
    public IHttpActionResult GetAccount(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * from users where users.UserID = @userID";

            Command.Parameters.AddWithValue("@userID", userID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [Route("api/getAccount")]
    public IHttpActionResult GetKien()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * from users";
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }



    [HttpPost]
    [Route("api/addBoard")]
    public IHttpActionResult AddBoard([FromBody] BoardModel board)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO boards (BoardName, CreatedDate, UserID, Labels, LabelsColor)
                                 VALUES (@BoardName, @CreatedDate, @UserID, @Labels, @LabelsColor)";
            Command.Parameters.AddWithValue("@BoardName", board.BoardName);
            Command.Parameters.AddWithValue("@CreatedDate", board.CreatedDate);
            Command.Parameters.AddWithValue("@UserID", board.UserID);
            Command.Parameters.AddWithValue("@Labels", board.Labels);
            Command.Parameters.AddWithValue("@LabelsColor", board.LabelsColor);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [HttpDelete]
    [Route("api/deleteBoard/{boardId}")]
    public IHttpActionResult DeleteBoard(int boardId)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM boards WHERE BoardID = @BoardID";
            Command.Parameters.AddWithValue("@BoardID", boardId);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [HttpPost]
    [Route("api/addChecklistitem")]
    public IHttpActionResult AddChecklistItem([FromBody] CheckListItemModel checklistitems)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO checklistitems (ChecklistID, Title)
                                 VALUES (@ChecklistID, @Title)";
            Command.Parameters.AddWithValue("@ChecklistID", checklistitems.ChecklistID);
            Command.Parameters.AddWithValue("@Title", checklistitems.Title);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpDelete]
    [Route("api/deleteChecklistitem/{Title}")]
    public IHttpActionResult DeleteChecklistitem(string Title)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM checklistitems WHERE Title = @Title";
            Command.Parameters.AddWithValue("@Title", Title);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }





    [HttpPost]
    [Route("api/addList")]
    public IHttpActionResult AddList([FromBody] ListModel list)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO lists (ListName, BoardID) VALUES (@ListName, @BoardID)";
            Command.Parameters.AddWithValue("@ListName", list.ListName);
            Command.Parameters.AddWithValue("@BoardID", list.BoardID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpPut]
    [Route("api/updateCard/{cardID}")]
    public IHttpActionResult UpdateCard(int cardID, [FromBody] CardModel card)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE cards SET DueDate = @DueDate WHERE CardID = @CardID";
            Command.Parameters.AddWithValue("@DueDate", card.DueDate);
            Command.Parameters.AddWithValue("@CardID", card.CardID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [Route("api/searchCards/{keyword}")]
    public IHttpActionResult SearchCards(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
WHERE CardName LIKE '%' + @Keyword + '%'
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.CardID DESC;";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            DataTable tableBoards = Command.GetDataTable();

            var response = new ResultModel
            {
                Data = tableBoards
            };

            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/searchCheckList/{keyword}")]
    public IHttpActionResult SearchCheckList(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM checklistitems WHERE checklistitems.Title LIKE '%' + @Keyword + '%'";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            DataTable tableBoards = Command.GetDataTable();

            var response = new ResultModel
            {
                Data = tableBoards
            };

            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }




    // GET api/values
    //[Authorize]
    [Route("api/getboards/{userID}")]
    public IHttpActionResult GetBoards(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select * from boards WHERE boards.userID = @userID";
            Command.Parameters.AddWithValue("@userID", userID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    // GET api/values
    //[Authorize]


    // GET api/values
    //[Authorize]
    //    [HttpGet]
    //    [Route("api/getCards/{listID}")]
    //    public IHttpActionResult GetChecklists(int listID)
    //    {
    //        try
    //        {
    //            Command.ResetAndOpen(CommandType.Text);
    //            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
    //FROM cards
    //LEFT JOIN checklists ON cards.cardID = checklists.cardID
    //LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
    //WHERE cards.ListID = @listID
    //GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist,
    //cards.Label, cards.Comment, cards.CardName, cards.StatusView,
    //cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
    //cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor";
    //            Command.Parameters.AddWithValue("@listID", listID);
    //            DataTable tableChecklists = Command.GetDataTable();
    //            var respone = new ResultModel
    //            {
    //                Data = JsonConvert.SerializeObject(tableChecklists)
    //            };
    //            return Ok(respone);
    //        }
    //        catch (Exception ex)
    //        {
    //            return Ok(ex.Message);
    //        }
    //    }



    [HttpPost]
    [Route("api/addCard")]
    public IHttpActionResult AddCard([FromBody] CardModel card)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO cards (ListID, CreatorID, CardName, Label, Comment, CreatedDate, DueDate, LabelColor)
                                 VALUES (@ListID, @CreatorID, @CardName, @Label, @Comment, @CreatedDate, @DueDate, @LabelColor)";
            Command.Parameters.AddWithValue("@ListID", card.ListID);
            Command.Parameters.AddWithValue("@CreatorID", card.CreatorID);
            Command.Parameters.AddWithValue("@CardName", card.CardName);
            Command.Parameters.AddWithValue("@Label", card.Label);
            Command.Parameters.AddWithValue("@Comment", card.Comment);
            Command.Parameters.AddWithValue("@CreatedDate", card.CreatedDate);
            Command.Parameters.AddWithValue("@DueDate", card.DueDate);
            Command.Parameters.AddWithValue("@LabelColor", card.LabelColor);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpGet]
    [Route("api/getChecklists/{cardID}")]
    public IHttpActionResult GetCardsList(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT checklists.ChecklistID,checklists.ChecklistTitle, checklistitems.Title FROM checklists
                                 INNER JOIN checklistitems ON checklists.ChecklistID = checklistitems.ChecklistID
                                 WHERE checklists.CardID = @cardID";
            Command.Parameters.AddWithValue("@cardID", cardID);
            DataTable tableChecklists = Command.GetDataTable();
            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableChecklists)
            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/getcards")]
    public IHttpActionResult GetCards()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.CardID DESC;";
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [Route("api/getcarddetail/{cardID}")]
    public IHttpActionResult GetCardDetail(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, lists.ListName, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
LEFT JOIN lists ON cards.CardID = lists.ListID
WHERE cards.CardID = 3
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, lists.ListName, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor;";
            Command.Parameters.AddWithValue("@cardID", cardID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [Route("api/sortCard")]
    public IHttpActionResult GetSortCard()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
FROM cards
LEFT JOIN checklists ON cards.cardID = checklists.cardID
LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
ORDER BY cards.DueDate ASC;";
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpGet]
    [Route("api/getLists/{boardID}")]
    public IHttpActionResult GetLists(int boardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM lists
                                 INNER JOIN cards ON lists.ListID = cards.ListID
                                 WHERE lists.BoardID = @boardID";
            Command.Parameters.AddWithValue("@boardID", boardID);
            DataTable tableChecklists = Command.GetDataTable();
            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableChecklists)
            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [HttpGet]
    [Route("api/getListOption/{boardID}")]
    public IHttpActionResult GetListOption(int boardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from lists where BoardID= @boardID";
            Command.Parameters.AddWithValue("@boardID", boardID);
            DataTable tableChecklists = Command.GetDataTable();
            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableChecklists)
            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/searchBoards/{keyword}")]
    public IHttpActionResult SearchBoards(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM boards WHERE BoardName LIKE '%' + @Keyword + '%'";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            DataTable tableBoards = Command.GetDataTable();

            var response = new ResultModel
            {
                Data = tableBoards
            };

            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/getComments/{cardID}")]
    public IHttpActionResult GetComments(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select users.UserID, users.AvatarUrl, users.Fullname, comments.Detail, comments.CommentID from users inner join comments
                                    on users.UserID = comments.UserID
                                    where comments.CardID= @cardID order by comments.CommentID DESC";

            Command.Parameters.AddWithValue("@cardID", cardID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpPost]
    [Route("api/addComment")]
    public IHttpActionResult AddComment([FromBody] CommentModel comment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO comments (UserID, CardID, Detail)
                                 VALUES (@UserID, @CardID, @Detail)";
            Command.Parameters.AddWithValue("@UserID", comment.UserID);
            Command.Parameters.AddWithValue("@CardID", comment.CardID);
            Command.Parameters.AddWithValue("@Detail", comment.Detail);

            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }
    [HttpDelete]
    [Route("api/deleteComment/{commentID}")]
    public IHttpActionResult DeleteComment(int commentID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM comments WHERE CommentID = @CommentID";
            Command.Parameters.AddWithValue("@CommentID", commentID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }
    [HttpPut]
    [Route("api/updateComment/{userID}/{commentID}")]
    public IHttpActionResult UpdateComment(int userID, int commentID, [FromBody] CommentModel comment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE comments SET Detail = @Detail WHERE CommentID = @CommentID AND UserID= @UserID";
            Command.Parameters.AddWithValue("@Detail", comment.Detail);

            Command.Parameters.AddWithValue("@CommentID", comment.CommentID);
            Command.Parameters.AddWithValue("@UserID", comment.UserID);


            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [Route("api/getNotifications")]
    public IHttpActionResult GetNotifications()
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select notifications.NotificationID,notifications.NotificationType,Content,notifications.CreatedDate,users.Username,boards.BoardName,cards.CardName,cards.CardID,boards.BoardID,boards.Labels from notifications inner join users
                                    on notifications.UserID = users.UserID
                                    inner join cards
                                    on notifications.CardID=cards.CardID
                                    inner join boards
                                    on notifications.BoardID=boards.BoardID
                                    inner join lists
                                    on notifications.BoardID=lists.BoardID";
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpGet]
    [Route("api/downloadfile")]
    public IHttpActionResult DownloadFile()
    {
        try
        {
            var fileName = "data.csv";
            var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName);

            if (!File.Exists(filePath))
            {
                return NotFound();
            }

            var fileContent = File.ReadAllBytes(filePath);

            var contentDisposition = new System.Net.Mime.ContentDisposition
            {
                FileName = fileName,
                Inline = false
            };
            HttpContext.Current.Response.Headers.Add("Content-Disposition", contentDisposition.ToString());

            var result = new HttpResponseMessage(HttpStatusCode.OK);
            result.Content = new ByteArrayContent(fileContent);
            result.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
            return ResponseMessage(result);
        }
        catch (Exception ex)
        {
            return InternalServerError(ex);
        }
    }

    [Route("api/writecsv/{userId}")]
    public IHttpActionResult GetFileCSV(int userId)
    {
        try
        {
            // Configure the CSV writer
            var config = new CsvConfiguration(CultureInfo.InvariantCulture)
            {
                Encoding = Encoding.UTF8,
                Delimiter = ","
            };

            // Write the data to a stream
            using (var memoryStream = new MemoryStream())
            using (var streamWriter = new StreamWriter(memoryStream, Encoding.UTF8))
            using (var csvWriter = new CsvWriter(streamWriter, config))
            {
                csvWriter.WriteField(userId.ToString());
                csvWriter.NextRecord();
                streamWriter.Flush();

                // Save the stream to a file
                var fileName = "data.csv";
                var filePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, fileName);
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    memoryStream.Seek(0, SeekOrigin.Begin);
                    memoryStream.CopyTo(fileStream);
                }

                // Return the file content to the client
                var csvContent = File.ReadAllText(filePath);
                return Ok(csvContent);
            }
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/getAttachments/{cardID}")]
    public IHttpActionResult GetAttachments(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"select * from attachments
                                    where attachments.CardID= @cardID order by attachments.AttachmentID DESC";

            Command.Parameters.AddWithValue("@cardID", cardID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpPost]
    [Route("api/addAttachment")]
    public IHttpActionResult UpdateAttachment([FromBody] AttachmentModel attachment)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO attachments(CardID, AttachmentPath, AttachmentName)
                                    VALUES(@CardID, @AttachmentPath, @AttachmentName)";

            Command.Parameters.AddWithValue("@CardID", attachment.CardID);
            Command.Parameters.AddWithValue("@AttachmentPath", attachment.AttachmentPath);
            Command.Parameters.AddWithValue("@AttachmentName", attachment.AttachmentName);



            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }



    [Route("api/getUser/{email}")]
    public IHttpActionResult GetUser(string email)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from users where users.Email = @email";

            Command.Parameters.AddWithValue("@email", email);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpDelete]
    [Route("api/deleteAttachment/{attachmentID}")]
    public IHttpActionResult DeleteAttachment(int attachmentID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM attachments WHERE AttachmentID = @AttachmentID";
            Command.Parameters.AddWithValue("@AttachmentID", attachmentID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpPut]
    [Route("api/changePassword/{userID}")]
    public IHttpActionResult UpdatePassword(int userID, [FromBody] UserModel user)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"UPDATE users SET Password=@Password WHERE UserID = @UserID";

            Command.Parameters.AddWithValue("@Password", user.Password);

            Command.Parameters.AddWithValue("@UserID", user.UserID);

            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }
    [Route("api/searchLists/{keyword}")]
    public IHttpActionResult SearchLists(string keyword)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT * FROM lists WHERE ListName LIKE '%' + @Keyword + '%'";
            Command.Parameters.AddWithValue("@Keyword", keyword);
            DataTable tableBoards = Command.GetDataTable();

            var response = new ResultModel
            {
                Data = tableBoards
            };


            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [HttpDelete]
    [Route("api/deleteMember/{memberID}")]
    public IHttpActionResult DeleteMember(int memberID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"DELETE FROM members WHERE members.id = @memberID";
            Command.Parameters.AddWithValue("@memberID", memberID);
            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }


    [Route("api/getmembers/{cardID}")]
    public IHttpActionResult GetMember(int cardID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"Select * from members 
                Where members.assignedTo = ( select members.assignedTo from cards where CardID = @CardID )";

            Command.Parameters.AddWithValue("@CardID", cardID);
            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

    [HttpPost]
    [Route("api/addMember")]
    public IHttpActionResult AddMember([FromBody] MemberModel member)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"INSERT INTO members(fullname, Email, AvatarUrl, assignedTo)
                                    VALUES(@fullname, @Email, @AvatarUrl, @assignedTo)";

            Command.Parameters.AddWithValue("@fullname", member.fullname);
            Command.Parameters.AddWithValue("@Email", member.Email);
            Command.Parameters.AddWithValue("@AvatarUrl", member.AvatarUrl);
            Command.Parameters.AddWithValue("@assignedTo", member.assignedTo);


            Command.ExecuteNonQuery();
            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [HttpDelete]
    [Route("api/deleteUser/{userId}")]
    public IHttpActionResult DeleteUser(int userId)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);

            // Delete related records from checklistitems
            Command.CommandText = @"DELETE FROM checklistitems WHERE ChecklistID IN (SELECT ChecklistID FROM checklists WHERE CardID IN (SELECT CardID FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=@ChecklistItemsUserID))))";
            Command.Parameters.AddWithValue("@ChecklistItemsUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from checklists
            Command.CommandText = @"DELETE FROM checklists WHERE CardID IN (SELECT CardID FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=@ChecklistUserID)))";
            Command.Parameters.AddWithValue("@ChecklistUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from attachments
            Command.CommandText = @"DELETE FROM attachments WHERE CardID IN (SELECT CardID FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID=@AttachmentUserID)))";
            Command.Parameters.AddWithValue("@AttachmentUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from comments
            Command.CommandText = @"DELETE FROM comments WHERE UserID=@CommentUserID";
            Command.Parameters.AddWithValue("@CommentUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from notifications
            Command.CommandText = @"DELETE FROM notifications WHERE UserID=@NotificationUserID";
            Command.Parameters.AddWithValue("@NotificationUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from cards
            Command.CommandText = @"DELETE FROM cards WHERE ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @CardUserID))";
            Command.Parameters.AddWithValue("@CardUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from lists
            Command.CommandText = @"DELETE FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @ListUserID)";
            Command.Parameters.AddWithValue("@ListUserID", userId);
            Command.ExecuteNonQuery();

            // Delete related records from boards
            Command.CommandText = @"DELETE FROM boards WHERE UserID = @BoardUserID";
            Command.Parameters.AddWithValue("@BoardUserID", userId);
            Command.ExecuteNonQuery();

            // Finally, delete the user record
            Command.CommandText = @"DELETE FROM users WHERE UserID = @UserUserID";
            Command.Parameters.AddWithValue("@UserUserID", userId);
            Command.ExecuteNonQuery();

            var response = new ResultModel { };
            return Ok(response);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }
    }

    [Route("api/getCards/{userId}")]
    public IHttpActionResult GetCardsWithUserID(int userID)
    {
        try
        {
            Command.ResetAndOpen(CommandType.Text);
            Command.CommandText = @"SELECT cards.*, COUNT(checklistitems.ChecklistItemID) AS 'SUM', SUM(CASE WHEN checklistitems.Completed = 1 THEN 1 ELSE 0 END) AS 'index_checked'
            FROM cards 
            LEFT JOIN checklists ON cards.cardID = checklists.cardID
            LEFT JOIN checklistitems ON checklists.checklistID = checklistitems.checklistID
            WHERE cards.ListID IN (SELECT ListID FROM lists WHERE BoardID IN (SELECT BoardID FROM boards WHERE UserID = @UserID))
            GROUP BY cards.cardID, cards.ListID, cards.AssignedToID, cards.CreatorID, cards.Checklist, 
            cards.Label, cards.Comment, cards.CardName, cards.StatusView, 
            cards.CreatedDate, cards.StartDate, cards.DueDate, cards.Attachment,
            cards.Description, cards.Activity, cards.IntCheckList, cards.LabelColor
            ORDER BY cards.CardID DESC;";
            Command.Parameters.AddWithValue("@UserID", userID);

            DataTable tableNhanVien = Command.GetDataTable();

            var respone = new ResultModel
            {
                Data = JsonConvert.SerializeObject(tableNhanVien)

            };
            return Ok(respone);
        }
        catch (Exception ex)
        {
            return Ok(ex.Message);
        }

    }

}



