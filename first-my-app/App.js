import { StatusBar } from "expo-status-bar";
import { StyleSheet, Text, View, Image } from "react-native";
import React from "react";

const Header = (props) => {
  return <Text>{props.title}</Text>;
};
const MyProfile = () => {
  return (
    <Profile
      name="JMK"
      uri="https://plus.unsplash.com/premium_photo-1669277336130-f5efae4b4d60?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1471&q=80"
      profileSize={40}
    />
  );
};
const Division = () => {
  return <Text>Division</Text>;
};
const FriendSection = () => {
  return <Text>FriendSection</Text>;
};
const FriendList = () => {
  return (
    <View>
      <Profile
        name="김씨"
        uri="https://images.unsplash.com/photo-1546527868-ccb7ee7dfa6a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
        profileSize={30}
      />
      <Profile
        name="이씨"
        uri="https://images.unsplash.com/photo-1601979031925-424e53b6caaa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80"
        profileSize={30}
      />
      <Profile
        name="박씨"
        uri="https://images.unsplash.com/photo-1510337550647-e84f83e341ca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1631&q=80"
        profileSize={30}
      />
      <Profile
        name="최씨"
        uri="https://images.unsplash.com/photo-1593134257782-e89567b7718a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=735&q=80"
        profileSize={30}
      />
      <Profile
        name="신씨"
        uri="https://images.unsplash.com/photo-1600804340584-c7db2eacf0bf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80"
        profileSize={30}
      />
    </View>
  );
};
// const Profile = (props) => {
//   return (
//     <View style={{ flexDirection: "row" }}>
//       <Image
//         source={{
//           uri: props.uri,
//         }}
//         style={{
//           width: props.profileSize,
//           height: props.profileSize,
//         }}
//       />
//       <Text>{props.name}</Text>
//     </View>
//   );
// };

class Profile extends React.Component {
  render() {
    return (
      <View style={{ flexDirection: "row" }}>
        <Image
          source={{
            uri: this.props.uri,
          }}
          style={{
            width: this.props.profileSize,
            height: this.props.profileSize,
          }}
        />
        <Text>{this.props.name}</Text>
      </View>
    );
  }
}

export default function App() {
  return (
    <View style={styles.container}>
      <Header title="친구"></Header>
      <MyProfile></MyProfile>
      <Division></Division>
      <FriendSection></FriendSection>
      <FriendList></FriendList>
      <StatusBar style="auto" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
