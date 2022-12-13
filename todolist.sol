//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

contract TodoList {

    struct Todo {
        string text;
        bool status;
    }

    Todo[] public todos ;

    function create(string memory _text) external {
        todos.push(Todo({
            text : _text,
            status: false
        }));

    }

    function updateText(uint _index , string memory _text , bool _status) external {
        todos[_index].text = _text;
        todos[_index].status = _status;
    }

    function get(uint _index) external view returns(string memory , bool) {
            return (todos[_index].text , todos[_index].status);
    }

    function toggle(uint _index) external {
        todos[_index].status = !todos[_index].status; 
    }

}