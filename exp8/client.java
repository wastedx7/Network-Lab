import java.io.*;
import java.net.*;

class UDPClient {
    public static void main(String args[]) {
        try {
            DatagramSocket ds;
            int clientPort = 1789;
            int serverPort = 1790;
            byte sendBuffer[] = new byte[1024];
            byte receiveBuffer[] = new byte[1024];
            ds = new DatagramSocket(clientPort);
            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
            InetAddress serverAddress = InetAddress.getByName("localhost");
            System.out.print("Enter a number: ");
            String input = br.readLine();
            sendBuffer = input.getBytes();
            // Send data to server
            DatagramPacket sendPacket = new DatagramPacket(
                    sendBuffer,
                    sendBuffer.length,
                    serverAddress,
                    serverPort);
            ds.send(sendPacket);
            // Receive response
            DatagramPacket receivePacket = new DatagramPacket(receiveBuffer, receiveBuffer.length);
            ds.receive(receivePacket);
            String response = new String(receivePacket.getData(), 0,
                    receivePacket.getLength());
            System.out.println("Server says: " + response);
            ds.close();
        } catch (Exception e) {
            System.out.println("Client Error: " + e);
        }
    }
}