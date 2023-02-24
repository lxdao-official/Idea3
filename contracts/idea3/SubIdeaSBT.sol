/**
 * this contract is used to add new idea addition to idea
 */
import "../sbt/SBT1155.sol";
import "../lib/ownable.sol";
import "./IIdeaSBT.sol";

contract SubIdeaSBT is SBT1155, Ownable {
    bool private _canEdit = true;
    bool private _feeOn = false;
    uint256 private _fee = 0.01 ether;
    mapping(uint256 => uint256) private idea_subidea_count;
    uint256 private subideaCount;

    IIdeaSBT private ideaSBT;

    function setFeeOn(bool feeOn) public onlyOwner {
        _feeOn = feeOn;
    }

    function setFee(uint256 fee) public onlyOwner {
        _fee = fee;
    }

    function setCanEdit(bool canEdit) public onlyOwner {
        _canEdit = canEdit;
    }

    constructor(address _ideaSBT, string memory uri_) ERC1155(uri_) {
        ideaSBT = IIdeaSBT(_ideaSBT);
    }

    function uri(uint256 id) public view override returns (string memory) {
        return ideaSBT.tokenURI(id);
    }

    mapping(uint256 => mapping(uint256 => SubIdeaStruct)) private idea_subideas;

    struct SubIdeaStruct {
        uint256 id;
        uint256 ideaId;
        string markdown;
        address submitter;
        uint256 createAt;
        uint256 updateAt;
    }

    event SubIdeaSubmitted(
        uint256 id,
        uint256 ideaId,
        string markdown,
        address submitter
    );

    function submitSubIdea(uint256 ideaId, string memory markdown)
        public
        payable
    {
        if (_feeOn) {
            require(msg.value >= _fee, "fee not enough");
        }

        uint256 subideaId = idea_subidea_count[ideaId];
        idea_subideas[ideaId][subideaId] = SubIdeaStruct(
            subideaId,
            ideaId,
            markdown,
            msg.sender,
            block.timestamp,
            block.timestamp
        );
        _mint(msg.sender, ideaId, 1, "");
        subideaCount += 1;
        idea_subidea_count[ideaId] += 1;
        emit SubIdeaSubmitted(subideaId, ideaId, markdown, msg.sender);
    }

    function getSubIdea(uint256 ideaId, uint256 subideaId)
        public
        view
        returns (SubIdeaStruct memory)
    {
        return idea_subideas[ideaId][subideaId];
    }

    function getSubIdeaCount(uint256 ideaId) public view returns (uint256) {
        return idea_subidea_count[ideaId];
    }

    function getAllSubIdeaCount() public view returns (uint256) {
        return subideaCount;
    }

    function editSubIdea(
        uint256 ideaId,
        uint256 subideaId,
        string memory markdown
    ) public {
        require(
            idea_subideas[ideaId][subideaId].submitter == msg.sender,
            "not the submitter"
        );
        idea_subideas[ideaId][subideaId].markdown = markdown;
        idea_subideas[ideaId][subideaId].updateAt = block.timestamp;
    }
}
