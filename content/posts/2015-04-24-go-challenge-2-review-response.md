---
layout: post
date: 2015-04-24
comments: true
categories:
  - golang
  - development
tags:
  - golang
  - development
summary: My entry to the Go Challenge 2 was reviewed and commented on by the challenge runner. I provide some feedback on his comments.
title: Go Challenge 2 Review Response
url: /go_challenge_2_review_response
---

I have been learning the Go programming language recently. And in order to help that I joined in on the [Go Challenge](http://golang-challenge.com/). At this point the 3rd challenge is available and 2nd is under review. 

The challenge author has [release some overview thoughts](http://blog.nella.org/golang-challenge-2-comments/) about the submissions. In it he talks about the challenge in general and some specifics about the solution's code. He also requests for permission to harshly critique someone's code. I requested and got the [extra critique](http://blog.nella.org/doing-it-the-hard-way/).

Summary of [general review](http://blog.nella.org/golang-challenge-2-comments/) comments:

* Solve partial encrypted box size read requests
* Solve partial encrypted box size packets from the network
* Set network timeout to support timeouts
* Limit message sizes

Overall I really think this is a difference between what the author thought he wrote for the challenge and what the participants read. Although, based on challenge #3 and what is being talked about in chat, I also think there is a bit of a confusion about the challenge overall. I think some participants in the challenge, me included, assume this is a teacher creating a lesson for us all to learn from. Trying their best to come up with a realistic looking problem for us. Instead I think the runners of the challenge think of this more like a real world work assignment. Of course for a work assignment you would always question every aspect of the assignment. It is part of the checks a business needs to make sure its doing the right thing at the right time. Although this is not the case for a teacher. What you are doing is fixed. The teacher isn't changing their lesson plans. Although the “how” is up for interpretation. (And normally grading) The “how” had a lot of discussion on the chat server for most of the 2 week challenge.

I'll go out on a limb here and bet that all of the participants in the teacher camp assumed we were sending only one message. I personally saw several conversations about only sending a single message. So I would guess there are also some in the work assignment camp that also thought we were only sending a single message.

With that in mind, a lot of his comments do not really apply any longer. If you are sending only one message over the unreliable network then getting an error in transmission is fatal. In almost every case there is no recovering from errors because the socket has already closed. Can't write nonce to network; fail. Can't read nonce; fail. Can't encrypt message; fail. Can't decrypt message; fail. Read partial message; fail. Wrote partial message; fail. Since the errors only happen on specific sides of the exchange the error messages also become clear. To make this more clear, perhaps the SecureReader and SecureWriter structs we created should have cached the last error.

In the case of a single message only his comments about sending the size are still valid. Sending the size would have allowed for one extra error condition; knowing when a partial, but decryptable message, is received. In the case of a partial message in the middle of a box the error would instead been failure to decrypt.

Summary of [personal review](http://blog.nella.org/doing-it-the-hard-way/) comments:

* Nonce used more than once
* Use of clever solution for sending nonce (`TeeReader`)
* Confusion over errors
* `MultiWriter` usage
* Use of `io.Copy` for echoing

I think most of his comments are from the miscommunications from the challenge for those in the teacher camp versus the work assignment camp. First he takes issue with saving the nonce, but it makes since in a stream based encryptor or decryptor. The full stream of the message might come from several Read or Write calls, and thus you need to save the nonce for encrypting or decrypting as you go. Even if the challenge was to make a multi-message system, each message would need to save it's nonce while its still communicating that single message.

Second issue is with a clever solution for sending the nonce and the use of `MultiWriter`. **I definitely should have added more documentation for this part of the solution.** And should remember to do so when using the pattern elsewhere. I think this is because its using the side effects just as much as the main code path.  To two pieces of code at issue are reading the 24 byte nonce from random while also sending to the remote connection. And the reading of a server connection and echoing it back to the client while also echoing to the console. Both of these are handled in a way that is familiar to Unix command line or Perl script writers. In both cases I'm using `TeeReader` and `MultiWriter` to work like the `tee` command. Just like in a long command line that is piping many commands in to the next, the `tee` command is used to write a piece of it to a file without breaking up the chain. Same goes for how a nonce is used to encrypt a message. The long piped command is reading from the user's input and encrypting it with a random nonce and writing it out to the network. Along the way the nonce is saved to a file. That file just happens to be the output writer for the network so the receiver can decrypt the message. The same principle is at work when server is echoing it's input. The long chain of commands is to receive a message from the client, decrypt it, re-encrypt it, and send back to client. Along the way the decrypted text is printed to the console by teeing onto standard out.

He also says there could be an error with reading from random for the nonce and saving it. I already address saving the nonce. The failure to read from random in a single message scenario is fatal. It is displayed to the user as a failure to read the nonce only on the client side.

Lastly, he is questionable about the use of `io.Copy`. For a single message over the network this method should be acceptable. The reason is because library will read until `EOF`, or because this is a network connect, a timeout. Performing as many Reads or Writes as needed in a loop. And because we saved the nonce we support stream based called like this. Wrap the input in a SecureReader, the output in a SecureWriter and combine with a `MultiWriter` sending to console and `io.Copy` does the rest.

My full submission is at https://github.com/golangchallenge/GCSolutions/tree/master/april15/normal/jason-clark

