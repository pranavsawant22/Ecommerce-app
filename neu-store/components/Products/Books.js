import { ListItem, Typography } from "@mui/material";
import React from "react";

const Books = ({props}) => {

  return (
    <>
      <ListItem>
        <Typography>Publisher: {props.publisher}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Fiction: {props.fiction}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Genre: {props.genre}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Language: {props.language}</Typography>
      </ListItem>
      <ListItem>
        <Typography>Author: {props.author}</Typography>
      </ListItem>
    </>
  );
};

export default Books;
