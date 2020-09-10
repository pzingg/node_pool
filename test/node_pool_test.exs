defmodule Datastore.NodePoolTest do
  use ExUnit.Case
  doctest NodePool

  @node_list [:"node-1@127.0.0.1", :"node-2@127.0.0.1"]

  test "01 NodePool starts empty" do
    status = NodePool.start_link([], no_start: true, no_stats: true)
    assert {:ok, pid} = status

    nodes = NodePool.get_nodes()
    assert nodes == []
    NodePool.stop()
  end

  test "02 NodePool starts with master" do
    status = NodePool.start_link([], no_start: true, no_stats: true, include_master: true)
    assert {:ok, pid} = status

    nodes = NodePool.get_nodes()
    assert nodes == [Node.self()]
    NodePool.stop()
  end

  test "03 NodePool starts with list" do
    status = NodePool.start_link(@node_list, no_start: true, no_stats: true)
    assert {:ok, pid} = status

    nodes = NodePool.get_nodes()
    assert nodes == @node_list
    NodePool.stop()
  end

  test "03 NodePool gets nodes" do
    status = NodePool.start_link(@node_list, no_start: true, no_stats: true)
    assert {:ok, pid} = status

    node1 = NodePool.get_node()
    assert node1
    assert Enum.member?(@node_list, node1)
    node2 = NodePool.get_node()
    assert node2
    assert Enum.member?(@node_list, node2)
    assert node2 != node1
    NodePool.stop()
  end

  test "03 NodePool gets nodes excluding master" do
    status = NodePool.start_link(@node_list, no_start: true, no_stats: true, include_master: true)
    assert {:ok, pid} = status

    master = Node.self()
    node1 = NodePool.get_node([master])
    assert node1
    assert node1 != master
    assert Enum.member?(@node_list, node1)
    node2 = NodePool.get_node([master])
    assert node2
    assert node2 != master
    assert Enum.member?(@node_list, node2)
    assert node2 != node1

    {nodes, _opts} = GenServer.call({:global, ElixirPoolMaster}, :get_state)

    assert nodes == [
             {999_999, master},
             {1_000_000, :"node-1@127.0.0.1"},
             {1_000_000, :"node-2@127.0.0.1"}
           ]

    NodePool.stop()
  end
end
