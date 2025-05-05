include console.inc

    .data
        mesg db 'Hello world',0


    .code
    Start:
        outstrln  offset mesg
        exit 0
    end Start

