import java.io.*;
import java.net.*;

class UDPServer {
    public static void main(String args[]) {
        try {
            DatagramSocket ds;
            int serverPort = 1790;
            int clientPort = 1789;
            byte buffer[] = new byte[1024];
            ds = new DatagramSocket(serverPort);
            System.out.println("Server is running...");
            while (true) {
                // Receive data from client
                DatagramPacket receivePacket = new DatagramPacket(buffer, buffer.length);
                ds.receive(receivePacket);
                String receivedData = new String(receivePacket.getData(), 0, receivePacket.getLength());
                System.out.println("Received: " + receivedData);
                String result;
                try {
                    int num = Integer.parseInt(receivedData.trim());
                    if (num % 2 == 0) {
                        result = num + " is even";
                    } else {
                        result = num + " is odd";
                    }
                } catch (NumberFormatException e) {
                    result = "Invalid input. Please send a number.";
                }
                // Send response back to client
                InetAddress clientAddress = receivePacket.getAddress();
                byte sendData[] = result.getBytes();
                DatagramPacket sendPacket = new DatagramPacket(
                        sendData,
                        sendData.length,
                        clientAddress,
                        clientPort);
                ds.send(sendPacket);
            }
        } catch (Exception e) {
            System.out.println("Server Error: " + e);
        }
    }
}